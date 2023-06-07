--
--		File: ICs.sql
--		Authors:
--		        - Gonçalo Bárias (ist1103124)
--		        - Raquel Braunschweig (ist1102624)
--              - Vasco Paisana (ist1102533)
--		Group: 2
--		Description: Creates the triggers for some of the integrity
--                   constraints commented in schema.

----------
-- (IC-2): A `workplace` is necessarily an `office` or `warehouse` but cannot be both.
----------

----------
-- (IC-3): An `order` must be in `contains`.
----------
