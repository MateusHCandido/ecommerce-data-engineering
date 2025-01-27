WITH filtered_geo AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY geolocation_zip_code_prefix ORDER BY geolocation_lat, geolocation_lng) AS row_num
    FROM relational.geolocation
    WHERE NOT (
        geolocation_zip_code_prefix IS NULL OR    
        geolocation_lat IS NULL OR
        geolocation_lng IS NULL OR
        geolocation_city IS NULL OR
        geolocation_state IS NULL    
    )
),
r_geo AS (
    SELECT *
    FROM filtered_geo
    WHERE row_num = 1 
)
INSERT INTO dimensional.geolocation(
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
SELECT 
	r_geo.geolocation_zip_code_prefix,
	r_geo.geolocation_lat,
	r_geo.geolocation_lng,
	r_geo.geolocation_city,
	r_geo.geolocation_state
FROM 
	r_geo
WHERE NOT EXISTS(
	SELECT 1
	FROM
		dimensional.geolocation d_geo
	WHERE
		d_geo.geolocation_zip_code_prefix = r_geo.geolocation_zip_code_prefix AND
		d_geo.geolocation_lat = r_geo.geolocation_lat AND
		d_geo.geolocation_lng = r_geo.geolocation_lng AND	
		d_geo.geolocation_city = r_geo.geolocation_city AND
		d_geo.geolocation_state = r_geo.geolocation_state
);