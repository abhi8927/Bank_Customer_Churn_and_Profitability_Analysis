CREATE VIEW vw_customer_profile AS
SELECT
  c.customer_id,
  c.surname,
  c.gender,
  c.age,
  c.tenure,
  c.credit_score,
  c.num_of_products,
  c.has_cr_card,
  c.is_active_member,
  c.balance,
  c.estimated_salary,
  c.churned,
  g.Geography AS geography
FROM dim_customer c
JOIN dim_geography g
  ON c.geography_id = g.geography_id;

CREATE VIEW vw_profitability AS
SELECT
  customer_id,
  balance,
  num_of_products,
  (10 * 12)
  + (balance * 0.002)
  - (5 * 12)
  - (num_of_products * 3 * 12) AS annual_profit
FROM dim_customer;

CREATE VIEW vw_churn_risk AS
SELECT
  customer_id,
  churned,
  (
    CASE WHEN is_active_member = 0 THEN 3 ELSE 0 END +
    CASE WHEN num_of_products = 1 THEN 2 ELSE 0 END +
    CASE WHEN tenure < 2 THEN 1 ELSE 0 END +
    CASE WHEN balance = 0 THEN 2 ELSE 0 END +
    CASE WHEN credit_score < 600 THEN 1 ELSE 0 END
  ) AS churn_risk_score
FROM dim_customer;

CREATE VIEW vw_high_value_at_risk AS
SELECT
  p.customer_id,
  p.annual_profit,
  r.churn_risk_score
FROM vw_profitability p
JOIN vw_churn_risk r
  ON p.customer_id = r.customer_id
WHERE p.annual_profit > 0
  AND r.churn_risk_score >= 5
ORDER BY p.annual_profit DESC;
