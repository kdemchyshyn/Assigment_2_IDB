create database assignment_2;

use assignment_2;

explain
select 
    e.FirstName || ' ' || e.MiddleInitial || ' ' || e.LastName as FullName,
    c.CityName,
    co.CountryName,
    s.SalesID,
    s.TotalPrice,
    s.Quantity,
    s.Discount,
    (
        select count(*)
        from sales s2
        where s2.SalesDate between '2010-01-01' and '2025-12-31'
            and s2.TotalPrice > 100
    ) as TotalHighValueSales,
    case 
        when s.Discount > 0 then 'Discounted'
        else 'Full Price'
    end as PriceType
from 
    sales s
    left join employees e on s.SalesPersonID = e.EmployeeID
    left join cities c on e.CityID = c.CityID
    left join countries co on c.CountryID = co.CountryID
where 
    s.SalesDate like '2018-05%'
    and s.Quantity in (
            select distinct Quantity
            from sales
            where Discount between 0.1 and 0.5
        )
order by 
    s.SalesID desc;
