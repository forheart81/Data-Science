/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select name from Facilities
where membercost != 0 

/* Q2: How many facilities do not charge a fee to members? */

select count(*) from Facilities
where membercost = 0

 

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select facid, name, membercost, monthlymaintenance 
from Facilities
where membercost > 0 and membercost < (monthlymaintenance*0.2)


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

select * from Facilities
where name like '%2'

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select name, monthlymaintenance, 
case when monthlymaintenance > 100 then 'expensive'
else 'cheap' end as cheap_or_not 
from Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

select surname, firstname from Members
where joindate = 
(select max(joindate) from Members)

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select concat(result.firstname, ' ', result.surname, ', ', f.name) from
(select distinct m.memid, m.surname, m.firstname, b.facid 
from members as m
inner join bookings as b
on m.memid = b.memid
and (b.facid = 0 or b.facid = 1)
order by surname) as result
join facilities as f
on result.facid = f.facid

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select concat(f.name, ', ', m.surname, ' ', m.firstname, ', ', case when b.memid = 0 then b.slots * f.guestcostelse b.slots * f.membercost end)  
from bookings b
inner join facilities f
on b.facid = f.facid
inner join members m
on m.memid = b.memid
where starttime between '2012-09-14 00:00:00' and '2012-09-15 00:00:00' and (case when b.memid = 0 then b.slots * f.guestcostelse b.slots * f.membercost end) > 30

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

select concat(result.name, ', ', m.firstname, ' ', m.surname, ', ', result.total_cost) 
from (
select b.memid, f.name,case when b.memid = 0 then b.slots * f.guestcostelse b.slots * f.membercost end as total_cost 
       from bookings b
       join facilities f
       on b.facid = f.facid
       and (b.starttime between '2012-09-14 00:00:00' and '2012-09-15 00:00:00')
       ) result
join members m
on result.memid = m.memid
and total_cost > 30
order by total_cost desc

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

select result2.* from(
       select result.name, sum(total_cost) as total_revenue from(
select b.memid, b.slots, b.starttime, f.name, f.membercost, f.guestcost, case when b.memid = 0 then b.slots * f.guestcostelse b.slots * f.membercost end as total_cost from bookings b
join facilities f
on b.facid = f.facid
       ) as result
       group by result.name
) as result2
where total_revenue < 1000
order by total_revenue

