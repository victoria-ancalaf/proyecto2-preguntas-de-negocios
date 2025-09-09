-- LIMPIEZA TABLA TECHNICAL
-- 1. Crear nueva tabla desde los datos originales 
CREATE TABLE `preguntas-de-negocio.desempeno_canciones.technical_copia` AS
SELECT * FROM `preguntas-de-negocio.desempeno_canciones.technical`;

-- 2. Identificar valores nulos (95 registros nulos en columna key, estos valores los mantenemos como null)
SELECT COUNTIF(track_id IS NULL) AS nulos_track_id,
COUNTIF(bpm IS NULL) AS nulos_bpm,
COUNTIF(`key` IS NULL) AS nulos_key,
COUNTIF(mode IS NULL) AS nulos_mode,
COUNTIF(`danceability_%` IS NULL) AS nulos_dance,
  COUNTIF(`valence_%` IS NULL) AS nulos_valence,
  COUNTIF(`energy_%` IS NULL) AS nulos_energy,
  COUNTIF(`acousticness_%` IS NULL) AS nulos_acoustic,
  COUNTIF(`instrumentalness_%` IS NULL) AS nulos_instrument,
  COUNTIF(`liveness_%` IS NULL) AS nulos_live,
  COUNTIF(`speechiness_%` IS NULL) AS nulos_speech
 FROM `preguntas-de-negocio.desempeno_canciones.technical_copia`;

 -- 3. Identificar valores duplicados. (Sin valores duplicados)
SELECT track_id, bpm,
COUNT(*)
FROM `preguntas-de-negocio.desempeno_canciones.technical_copia`
GROUP BY track_id, bpm
HAVING COUNT(*) > 1;

-- 4. Identificar y tratar valores atipicos en variables categoricas. Los valores se mantienen como estaban, ya que no hay atipicos.
SELECT `key`,mode,
REGEXP_REPLACE(`key`,r'[^a-zA-Z0-9 .,()#!\'"?:-]', '')
AS key_limpio,
REGEXP_REPLACE(mode,r'[^a-zA-Z0-9 .,()#!\'"?:-]', '')
AS mode_limpio,
FROM `preguntas-de-negocio.desempeno_canciones.technical_copia`;

-- 5. Identificar valores atípicos en variables numéricas
SELECT
MIN(track_id) AS min_id,
MAX(track_id) AS max_id,
MIN(bpm) AS min_bpm,
MAX(bpm) AS max_bpm,
AVG(bpm) AS avg_bpm,
MIN(`danceability_%`) AS min_dance,
MAX(`danceability_%`) AS max_dance,
AVG(`danceability_%`) AS avg_dance,
MIN(`valence_%`) AS min_valence,
MAX(`valence_%`) AS max_valence,
AVG(`valence_%`) AS avg_valence,
MIN(`energy_%`) AS min_energy,
MAX(`energy_%`) AS max_energy,
AVG(`energy_%`) AS avg_energy,
MIN(`acousticness_%`) AS min_acoustic,
MAX(`acousticness_%`) AS max_acoustic,
AVG(`acousticness_%`) AS avg_acoustic,
MIN(`instrumentalness_%`) AS min_instrument,
MAX(`instrumentalness_%`) AS max_instrument,
AVG(`instrumentalness_%`) AS avg_instrument,
MIN(`liveness_%`) AS min_liveness,
MAX(`liveness_%`) AS max_liveness,
AVG(`liveness_%`) AS avg_liveness,
MIN(`speechiness_%`) AS min_speech,
MAX(`speechiness_%`) AS max_speech,
AVG(`speechiness_%`) AS avg_speech,
FROM `preguntas-de-negocio.desempeno_canciones.technical_copia`;

-- 6. Se encontró el valor atípico en track_id: '0:00'. Decidimos eliminar este registro.
DELETE FROM `preguntas-de-negocio.desempeno_canciones.technical_copia`
WHERE track_id = '0:00';

-- 7. Convertir tipos de dato: de string a integer. Columna track_id. Creamos nueva tabla convirtiendo el tipo de dato.
CREATE TABLE `preguntas-de-negocio.desempeno_canciones.technical_clean` AS
SELECT
    CAST(track_id AS INT64) AS track_id_int,
    bpm, `key`, mode, `danceability_%`, `valence_%`, `energy_%`, `acousticness_%`, `instrumentalness_%`, `liveness_%`, `speechiness_%`
FROM `preguntas-de-negocio.desempeno_canciones.technical_copia`;

-- 8. En la nueva tabla con los datos procesados, renombramos la columna como estaba anteriormente
ALTER TABLE `preguntas-de-negocio.desempeno_canciones.technical_clean`
RENAME COLUMN track_id_int TO track_id;

-- 9. Crear vista con los datos limpios
CREATE VIEW `preguntas-de-negocio.desempeno_canciones.technical_view` AS
SELECT * 
FROM `preguntas-de-negocio.desempeno_canciones.technical_clean`;




