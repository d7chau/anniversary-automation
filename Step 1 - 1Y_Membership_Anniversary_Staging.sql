/* SELECTING MEMBERS ELIGIBLE FOR 1-YEAR ANNIVERSARY CAMPAIGN */

SELECT         MEMBER.*,
               /* ASSIGN DISCOUNT TIER BASED ON MEMBER'S TOTAL SPEND IN THE LAST YEAR */
               CASE
                    WHEN X.TotalSpent > 0 AND X.TotalSpent <= 500 THEN '10%'
                    WHEN X.TotalSpent > 500 AND X.TotalSpent <= 1000 THEN '15%'
                    ELSE '20%'
               END AS MembershipDiscount,
               X.TotalSpent,
               /* SETTING DISCOUNT EXPIRATION TO 1 MONTH FROM TODAY */
               DATEADD(MONTH, 1, GETDATE() AT TIME ZONE 'Central Standard Time' AT TIME ZONE 'Eastern Standard Time') AS DiscountExpiration,
               /* CAPTURE CURRENT TIMESTAMP FOR JOURNEY ENTRY */
               GETDATE() AT TIME ZONE 'Central Standard Time' AT TIME ZONE 'Eastern Standard Time' AS JourneyEntryDate

FROM           [Membership_Master_DE] MEMBER

/* CALCULATION OF TOTAL SPENT WITHIN LAST YEAR */
INNER JOIN (
               SELECT         MemberID,
                              SUM(Amount) AS TotalSpent
               FROM           [Transactions_DE]
               WHERE          TransactionDate >= DATEADD(YEAR, -1, GETDATE() AT TIME ZONE 'Central Standard Time' AT TIME ZONE 'Eastern Standard Time')
               GROUP BY       MemberID  
           ) X
ON         MEMBER.MemberID = X.MemberID

/* CAMPAIGN CRITERIA */

/* INCLUDING MEMBERS WHO ARE OPTED INTO EMAIL */
WHERE          MEMBER.OptInStatus = 1

/* INCLUDING MEMBERS ON THEIR 1 YEAR ANNIVERSARY FROM MEMBER JOINED DATE */
AND            CAST(DATEADD(YEAR, 1, MEMBER.JoinDate) AS DATE) = CAST(GETDATE() AT TIME ZONE 'Central Standard Time' AT TIME ZONE 'Eastern Standard Time' AS DATE)

/* INCLUDING MEMBERS WHO HAVE MADE A TRANSACTION WITHIN THE LAST YEAR */
AND            EXISTS     (
                              SELECT         1
                              FROM           [Transactions_DE] TXN
                              WHERE          MEMBER.MemberID = TXN.MemberID
                              AND            TXN.TransactionDate >= DATEADD(YEAR, -1, GETDATE() AT TIME ZONE 'Central Standard Time' AT TIME ZONE 'Eastern Standard Time')
                          )

/* EXCLUDING MEMBERS WHO HAVE ALREADY ENTERED THE JOURNEY (NO REPEAT RECORDS AS IT IS ONE TIME ONLY) */
AND            NOT EXISTS (
                              SELECT         1
                              FROM           [1Y_Membership_Anniversary_JourneyEntry] JOURNEY
                              WHERE          MEMBER.MemberID = JOURNEY.MemberID
                          )
