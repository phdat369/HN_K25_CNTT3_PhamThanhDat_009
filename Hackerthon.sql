-- Tạo database
create database hackarthon;
use hackarthon;
-- Tạo bảng Passengers (Hành khách)
create table passengers (
   passenger_id varchar(5) primary key,
   full_name varchar(100) not null,
   email varchar(100) not null unique,
   phone varchar(15) not null unique
);
-- Tạo bảng Airlines (Hãng hàng không)
create table airlines (
   airline_id varchar(5) primary key,
   airline_name varchar(100) not null unique
);
-- Tạo bảng Flights (Chuyến bay)
create table flights (
   flight_id varchar(5) primary key,
   route_name varchar(100) not null unique,
   airline_id varchar(5) not null,
   ticket_price decimal(10,2) not null,
   available_seats int not null,
   foreign key (airline_id) references airlines (airline_id)
);
-- Tạo bảng Bookings (Đặt chỗ)
create table bookings (
   booking_id int primary key auto_increment,
   passenger_id varchar(5) not null,
   flight_id varchar(5) not null,
   status varchar(20)  not null check (status in ('Booked','Boarded','Cancelled')),
   booking_date date not null,
   foreign key (passenger_id) references passengers (passenger_id),
   foreign key (flight_id) references flights (flight_id),
   unique(passenger_id,flight_id)
);
-- Thêm dữ liệu vào bảng Passengers (Hành khách)
insert into passengers (passenger_id,full_name,email,phone)
values ('P01','Trần Văn Bình','binh.tv@gmail.com','0981111111'),
       ('P02','Lê Thị Hoa','hoa.lt@gmail.com','0982222222'),
       ('P03','Nguyễn Trọng Tuấn','tuan.nt@gmail.com','0983333333'),
       ('P04','Hoàng Minh Châu','chau.hm@gmail.com','0984444444'),
       ('P05','Đinh Kiều Oanh','oanh.dk@gmail.com','0985555555');
-- Thêm dữ liệu vào bảng Airlines (Hãng hàng không)
insert into airlines (airline_id,airline_name)
values ('A01','Vietnam Airlines'),
       ('A02','VietJet Air'),
       ('A03','Bamboo Airways'),
       ('A04','Pacific Airlines');
-- Thêm dữ liệu vào bảng Flights (Chuyến bay)
insert into flights (flight_id,route_name,airline_id,ticket_price,available_seats)
values ('F01','HN-HCM','A01',2500000.00,50),
       ('F02','HN-DN','A01',1500000.00,30),
       ('F03','HCM-DN','A02',1200000.00,40),
       ('F04','HN-PQ','A03',3000000.00,20),
       ('F05','HCM-DL','A04',1000000.00,15);
-- Thêm dữ liệu vào bảng Bookings (Đặt chỗ) 
insert into bookings (passenger_id,flight_id,status,booking_date)
values ('P01','F01','Booked','2025-10-01'),
       ('P02','F03','Boarded','2025-10-02'),
       ('P01','F02','Boarded','2025-10-03'),
       ('P04','F05','Cancelled','2025-10-04'),
       ('P05','F01','Booked','2025-10-05');
-- Phần 1 Câu 3: 
update flights 
set available_seats = available_seats + 10,
    ticket_price = ticket_price * 1.05
where route_name = 'HN-PQ';
-- Phần 1 Câu 4:
update passengers
set phone = '0999999999'
where passenger_id = 'P03';
-- Phần 1 Câu 5: 
delete
from bookings
where (status = 'Cancelled') and (booking_date < '2025-10-03');
-- Phần 2 Câu 6:
select flight_id,route_name,ticket_price 
from flights
where (ticket_price between 1200000 and 2500000) and (available_seats > 0);
-- Phần 2 Câu 7:
select full_name,email
from passengers 
where full_name like ('Trần%');
-- Phần 2 Câu 8:
select booking_id,passenger_id,booking_date
from bookings
order by booking_date desc;
-- Phần 2 Câu 9:
select route_name
from flights
order by ticket_price desc
limit 3;
-- Phần 2 Câu 10:
select route_name,available_seats 
from flights
limit 2
offset 2;
-- Phần 3 Câu 11:
select booking_id,
       (select full_name
		from passengers p
        where p.passenger_id = b.passenger_id) as full_name,
	   (select route_name
		from flights f
		where f.flight_id = b.flight_id) as route_name,
        booking_date
from bookings b
where status = 'Booked';
-- Phần 3 Câu 12: 
select (select airline_name
        from airlines a 
        where a.airline_id = f.airline_id) as airline_name,
        route_name
from flights f;
-- Phần 3 Câu 13:
select status, count(booking_id) as total_bookings
from bookings
group by status;
-- Phần 3 Câu 14:
select (select full_name
        from passengers p
        where p.passenger_id = b.passenger_id) as full_name
from bookings b
group by b.passenger_id
having count(b.passenger_id) >= 2;
-- Phần 3 Câu 15:
select flight_id,route_name,ticket_price
from flights
where ticket_price < (select avg(ticket_price) 
			   from flights);
-- Phần 3 Câu 16: 
select (select full_name
        from passengers p
        where p.passenger_id = b.passenger_id) as full_name,
	   (select phone
        from passengers p 
        where p.passenger_id = b.passenger_id) as phone
from bookings b
where b.flight_id = (select flight_id
                     from flights
					 where route_name = 'HN-HCM');