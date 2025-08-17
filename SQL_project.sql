-- Total deposits by gender
select  g.`Gender` ,sum(b.`Bank Deposits`) as total_deposits from `banking-clients` b
 join gender g on b.GenderId=g.GenderId 
 group by g.Gender
 order by total_deposits desc;
 
 
-- Top 5 clients with the highest total assets
SELECT 
    b.`Client ID`, 
    b.`Name`, 
    (b.`Bank Deposits` 
     + b.`Checking Accounts` 
     + b.`Saving Accounts` 
     + b.`Foreign Currency Account` 
     + b.`Superannuation Savings`) AS total_assets
FROM `banking-clients` b
order by total_assets desc
limit 5;

-- Average account balances grouped by branch
select br.`Banking Relationship`,
	AVG(b.`Checking Accounts`) as avg_checkingaccount,
    AVG(b.`Saving Accounts`) as avg_savingaccount,
    AVG(b.`Foreign Currency Account`) as avg_foreignaccount
FROM `banking-clients` b
join `banking-realtionships` br on b.`BRId`=br.`BRId`
group by br.`Banking Relationship`;


--  Clients who have both foreign currency accounts and business lending
SELECT 
    b.`Client ID`, 
	b.`Name`,
    b.`Foreign Currency Account` ,
    b.`Business Lending` 
FROM `banking-clients` b
where b.`Foreign Currency Account`>0 and b.`Business Lending` >0;


--  Branch with the highest number of clients
select br.`Banking Relationship`,
	count(b.`Client ID`) as total_clients
FROM `banking-clients` b
join `banking-realtionships` br on b.`BRId`=br.`BRId`
group by br.`Banking Relationship`
order by total_clients desc;


-- Clients assigned to each investment advisor
select 
	ia.`Investment Advisor`,
    count(b.`Client ID`) as No_of_clients
from `banking-clients` b
join `investment-advisiors` ia on b.`IAId`=ia.`IAId`
group by ia.`Investment Advisor`
order by No_of_clients desc;


--  Gender distribution of clients across branches
select  g.`Gender` ,br.`Banking Relationship`, count(b.`Client ID`) as total_clients 
from `banking-clients` b
join gender g on b.GenderId=g.GenderId 
join `banking-realtionships` br on b.`BRId`=br.`BRId`
group by  g.`Gender`,br.`Banking Relationship`
order by br.`Banking Relationship`;
 
 
-- Clients with deposits above the branch average
select 
	b.`Name`, b.`Bank Deposits`,br.`Banking Relationship`
from `banking-clients`b
join `banking-realtionships` br on b.`BRId`=br.`BRId`
where b.`Bank Deposits`>(
	select AVG(b1.`Bank Deposits`)
    from `banking-clients`b1
    where b1.BRId=b.BRId);


--  Top 3 investment advisors by total client assets
SELECT 
    ia.`Investment Advisor`, 
    sum(b.`Bank Deposits` 
     + b.`Checking Accounts` 
     + b.`Saving Accounts` 
     + b.`Foreign Currency Account` 
     + b.`Superannuation Savings`) AS total_assets
FROM `banking-clients` b
join `investment-advisiors` ia on b.IAId=ia.IAId
group by  ia.`Investment Advisor`
order by total_assets desc
limit 3;


-- Clients at high risk weighting
select distinct(`Risk Weighting`) from `banking-clients`;

select 
	b.`Client ID`, 
    b.`Name`,
    b.`Risk Weighting`
FROM `banking-clients` b
where b.`Risk Weighting`>=3
order by  b.`Risk Weighting` desc;


-- Nationality-wise client distribution
SELECT b.Nationality, COUNT(b.`Client ID`) AS total_clients
FROM `banking-clients` b
GROUP BY b.Nationality
ORDER BY total_clients DESC;


--  Yearly client onboarding trend
select
	year(str_to_date(b.`Joined Bank`,'%d/%m/%Y')) as Year,-- the joined bank column is stored as text.
    count(b.`Client ID`) as total_clients
FROM `banking-clients` b
group by year(str_to_date(b.`Joined Bank`,'%d/%m/%Y'))
order by Year;


--  Branches with highest property ownership value
select
	br.`Banking Relationship`,
    sum(b.`Properties Owned`) as Total_property_owned
from `banking-clients` b
join `banking-realtionships` br on b.`BRId`=br.`BRId`
group by br.`Banking Relationship`
order by Total_property_owned desc;
	

--  Advisor performance: Average risk profile of their clients
SELECT ia.`Investment Advisor`, AVG(b.`Risk Weighting`) AS avg_risk
FROM `banking-clients` b
join `investment-advisiors` ia on b.IAId=ia.IAId
group by  ia.`Investment Advisor`
ORDER BY avg_risk DESC;