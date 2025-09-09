SELECT 
CORR(streams, participacion_total_playlists) AS streams_playlists,
CORR(streams, in_spotify_playlists) AS streams_spotify_playlists,
CORR(participacion_total_playlists, in_spotify_playlists) AS totalplaylists_spotify_playlists,
CORR(streams, in_apple_playlists) AS streams_apple_playlists,
CORR(streams, in_deezer_playlists) AS streams_deezer_playlists,
CORR(streams, bpm) AS streams_bpm,
CORR(streams, `danceability_%`) AS streams_danceability,
CORR(streams, `energy_%`) AS streams_energy,
CORR(streams, `speechiness_%`) AS streams_speechiness,
CORR(streams, `liveness_%`) AS streams_liveness,
CORR(streams, in_spotify_charts) AS streams_spotify_charts,
CORR(streams, in_apple_charts) AS streams_apple_charts,
CORR(streams, in_deezer_charts) AS streams_deezer_charts,
CORR(streams, in_shazam_charts) AS streams_shazam_charts,
FROM `preguntas-de-negocio.desempeno_canciones.data_canciones_completa`;


WITH
artistas_mas_canciones AS (
  SELECT
  artist_s__name,
  COUNT(track_id) AS total_canciones,
  SUM(streams) AS total_streams
  FROM `preguntas-de-negocio.desempeno_canciones.data_canciones_completa`
  GROUP BY artist_s__name
)
SELECT
  CORR(total_streams, total_canciones) AS streams_artistas_con_mas_canciones
  FROM artistas_mas_canciones;
