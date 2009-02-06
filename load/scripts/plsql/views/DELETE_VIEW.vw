CREATE OR REPLACE FORCE VIEW CABIODEV.DELETE_VIEW
(THEROW)
AS 
SELECT MAX(ROWID) theROW FROM PROTOCOL_AGENTS pout WHERE
  EXISTS (SELECT PRO_ID FROM PROTOCOL_AGENTS pin
    WHERE pout.agent_id = pin.agent_id
	  AND pout.pro_id = pin.pro_id
	  GROUP BY pin.agent_id, pin.pro_id
	  HAVING COUNT(*) > 1)
	  GROUP BY pro_id, agent_id
	  ORDER BY pro_id;


