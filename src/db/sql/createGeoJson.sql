SELECT jsonb_build_object(
    'type',     'FeatureCollection',
    'features', jsonb_agg(features.feature)
) FROM (
  SELECT jsonb_build_object(
    'type',       'Feature',
    'gid',         $[id],
    'geometry',   ST_AsGeoJSON(ST_Transform($[geom:raw],4326))::jsonb,
    'properties', to_jsonb(inputs) - $[geom]
  ) AS feature
  FROM (SELECT * FROM $[table:raw]) inputs) features;