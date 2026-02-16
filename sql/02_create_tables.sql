CREATE TABLE stg_churn (
  RowNumber INT,
  CustomerId BIGINT,
  Surname VARCHAR(100),
  CreditScore INT,
  Geography VARCHAR(50),
  Gender VARCHAR(10),
  Age INT,
  Tenure INT,
  Balance DECIMAL(12,2),
  NumOfProducts INT,
  HasCrCard TINYINT,
  IsActiveMember TINYINT,
  EstimatedSalary DECIMAL(12,2),
  Exited TINYINT
);

CREATE TABLE dim_geography AS
SELECT DISTINCT Geography
FROM stg_churn;

ALTER TABLE dim_geography
  ADD geography_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

CREATE TABLE dim_customer AS
SELECT
  s.CustomerId AS customer_id,
  s.Surname AS surname,
  s.Gender AS gender,
  s.Age AS age,
  s.Tenure AS tenure,
  s.CreditScore AS credit_score,
  s.EstimatedSalary AS estimated_salary,
  s.NumOfProducts AS num_of_products,
  s.HasCrCard AS has_cr_card,
  s.IsActiveMember AS is_active_member,
  s.Balance AS balance,
  s.Exited AS churned,
  g.geography_id AS geography_id
FROM stg_churn s
JOIN dim_geography g
  ON s.Geography = g.Geography;
