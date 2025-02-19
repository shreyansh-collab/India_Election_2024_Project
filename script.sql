create database electors_data;
use electors_data;
create table election_data(
state_name varchar(50),
ac_name varchar(50),
pc_name varchar(50),
electors_male int,
electors_female int,
electors_other int,
electors_general int,
electors_service_male int,
electors_service_female int,
electors_service_total int,
total_NRI int,
electors_total int,
votes_polled_evm int
);
-- Total voter turnout per state
select state_name, 
sum(votes_polled_evm) as votes_cast , 
sum(electors_total) as total_electors,
round(((sum(votes_polled_evm)/sum(electors_total))*100),2) as voter_turnout
from election_data
group by state_name 
order by voter_turnout desc;

-- Male vs Female Voter Distribution per State 
select state_name, male_count,
((sum(male_count))/sum(male_count + female_count))*100 as male_voters,
female_count ,
((sum( female_count))/sum(male_count + female_count))*100 as female_voters
from (select state_name, 
sum(electors_male + electors_service_male) as male_count,
sum(electors_female + electors_service_female) as female_count
from election_data
group by state_name) as statewise_count
group by state_name
order by female_voters desc;

-- Find constituencies with the lowest voter turnout
select ac_name , state_name , 
(votes_polled_evm * 100.0 / electors_total) as turnout_percentage
from election_data
where electors_total <> 0
AND (votes_polled_evm * 100.0 / electors_total) > 0
order by turnout_percentage asc ;

-- Find constituencies with the highest voter turnout
select ac_name , state_name , 
(votes_polled_evm * 100.0 / electors_total) as turnout_percentage
from election_data
where electors_total <> 0
AND (votes_polled_evm * 100.0 / electors_total) > 0
order by turnout_percentage desc ;


-- Find states where a high percentage of 
-- registered voters did not vote
select state_name , 
sum(electors_total) - sum(votes_polled_evm) as non_voters,
  ((SUM(electors_total) - SUM(votes_polled_evm)) * 100.0 / SUM(electors_total)) AS non_voters_percentage
from election_data
group by state_name
order by non_voters_percentage desc;

-- Find ACs where a high percentage of 
-- registered voters did not vote
select state_name, ac_name,
(electors_total - votes_polled_evm) as non_voters,
((electors_total - votes_polled_evm)*100 / electors_total) as non_voter_percentage
from election_data 
order by non_voter_percentage desc;

-- Do larger ACs have lower turnout?
select ac_name , state_name, electors_total,
(votes_polled_evm *100/ electors_total) as voter_turnout
from election_data
where  electors_total > 0
AND (votes_polled_evm *100/ electors_total) <>0
order by electors_total desc;







