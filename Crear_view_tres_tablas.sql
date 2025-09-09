-- Unir tablas + Creación de variable de participación total en la lista de reproducción. Sumar in_spotify_playlists, in_apple_playlists, in_deezer_playlists.
CREATE VIEW `preguntas-de-negocio.desempeno_canciones.data_canciones_completa` AS
SELECT
  spotify.*,
  competition.* EXCEPT(track_id),
  technical.* EXCEPT(track_id),
  (in_spotify_playlists + in_apple_playlists + in_deezer_playlists) AS participacion_total_playlists
FROM `preguntas-de-negocio.desempeno_canciones.spotify_clean` AS spotify
LEFT JOIN `preguntas-de-negocio.desempeno_canciones.competition_clean` AS competition 
ON spotify.track_id = competition.track_id
LEFT JOIN `preguntas-de-negocio.desempeno_canciones.technical_clean` AS technical
ON spotify.track_id = technical.track_id;

SELECT * FROM `preguntas-de-negocio.desempeno_canciones.data_canciones_completa`

-- Construir tablas auxiliares. Crear una tabla temporal para calcular el total de canciones por artista solista (582 registros)
WITH canciones_artista_solista AS (
  SELECT 
  COUNT(*) AS total_canciones_por_artista_solista
  FROM `preguntas-de-negocio.desempeno_canciones.data_canciones_completa`
  WHERE artist_count = 1
)
SELECT * FROM canciones_artista_solista

