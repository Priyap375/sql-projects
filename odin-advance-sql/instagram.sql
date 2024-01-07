-- 1. How many times does the average user post?
with Posts as
			( select u.id, count(p.id) as post_count
			  from users u 
			  left join photos p 
			  on p.user_id = u.id
			  group by u.id)
select avg(post_count) as avg_post_per_user from Posts ;

-- 2. Find the top 5 most used hashtags.

WITH TagCounts AS
    ( SELECT t.tag_name, COUNT(pt.tag_id) AS tag_count,
        RANK() OVER (ORDER BY COUNT(pt.tag_id) DESC) AS tag_rank
    FROM tags t
    JOIN photo_tags pt ON t.id = pt.tag_id
    GROUP BY t.tag_name)

SELECT tag_name,tag_count
FROM TagCounts
WHERE tag_rank <= 5;

-- 3.Find users who have liked every single photo on the site.

select u.username, l.user_id 
from users u 
join likes l
on u.id = l.user_id
group by u.id 
having count(l.photo_id) = (select count(*) from photos);

-- 4.Retrieve a list of users along with their usernames and the rank of their account creation,
--  ordered by the creation date in ascending order.

select *, rank() over(order by created_at) as ranking
from users
order by created_at;

-- 5.List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted the comments. 
-- Include the comment count for each photo

select c.id,c.comment_text,p.id as photo_id,p.image_url, u.username , count(*)over (partition by p.id) as comments_count
from comments c 
join photos p 
on c.photo_id = p.id 
join users u 
on c.user_id = u.id
order by p.id;

-- 6.For each tag, show the tag name and the number of photos associated with that tag.
--  Rank the tags by the number of photos in descending order.

select t.tag_name, count(p.photo_id) as photos_count ,
rank() over (order by count(p.photo_id) desc) as ranks
from tags t 
left join photo_tags p 
on t.id = p.tag_id
group by t.tag_name;

-- 7.List the usernames of users who have posted photos along with the count of photos they have posted.
-- Rank them by the number of photos in descending order.

select u.username, count(p.id) as photo_counts,
rank()over(order by count(p.id) desc) as ranks
from users u 
join photos p
on u.id = p.user_id
group by u.id, u.username;


-- 8.Display the username of each user along with the creation date of their first posted photo and
-- the creation date of their next posted photo.

Select u.username,
    MIN(p1.created_at) AS first_posted_photo
--    MIN(p2.created_at) AS next_posted_photo
FROM users u
LEFT JOIN 
photos p1 ON u.id = p1.user_id
-- JOIN
-- photos p2 ON u.id = p2.user_id AND p2.created_at > p1.created_at
GROUP BY u.username;


with user_photos as(
            Select u.id, u.username, p.created_at,
            lead(p.created_at) over(partition by u.id order by p.created_at desc) as next_posted_photo
			FROM users u
			LEFT JOIN photos p
            ON u.id = p.user_id)
            
select up.username, MIN(up.created_at) as first_posted_photo
from user_photos up group by up.id, up.username;

-- 9.For each comment, show the comment text, the username of the commenter,
--  and the comment text of the previous comment made on the same photo.

select c.comment_text, u.username,
lag(c.comment_text) over(partition by c.photo_id order by c.created_at) as previous_comment_text
from comments c 
left join users u 
on c.user_id = u.id;

-- 10. Show the username of each user along with the number of photos they have posted and 
-- the number of photos posted by the user before them and after them, based on the creation date.

select u.username, count(p.id) as num_of_photos,
lag(count(p.id), 1, 0) over(order by u.created_at) as photos_before,
lead(count(p.id), 1, 0) over(order by u.created_at) as photos_after
from users u 
join photos p 
on p.user_id = u.id
group by u.id
order by u.created_at;










			
                