use assignment_2;

alter table sales add primary key(SalesID);
alter table employees add primary key(EmployeeID);
alter table cities add primary key(CityID);
alter table countries add primary key(CountryID);

alter table sales add index SalesDateIDX (SalesDate);
alter table sales add index QuantityDiscountIDX (Quantity, Discount);

explain
with UniqeQuantity as
(
    select Quantity
    from sales
    where Discount between 0.1 and 0.5
)
select 
    concat(e.FirstName, ' ', e.MiddleInitial, ' ', e.LastName) as FullName,
    c.CityName,
    co.CountryName,
    s.SalesID,
    s.TotalPrice,
    s.Quantity,
    s.Discount,
    if(s.Discount > 0, 'Discounted', 'Full Price') as PriceType
from sales s force index (SalesDateIDX)
left join employees e on s.SalesPersonID = e.EmployeeID
left join cities c on e.CityID = c.CityID
left join countries co on c.CountryID = co.CountryID
left join UniqeQuantity uq ON s.Quantity = uq.Quantity
where 
    s.SalesDate between '2018-05-01' and '2018-05-31'
    and uq.Quantity is not null
order by s.SalesID desc;