/* UPDATING JOURNEY ENTRY DE TO FLAG MEMBERS WHO HAVE REDEEMED */

SELECT          JOURNEY.MemberID,
                1 AS HasClaimedDiscount -- Flag Indicating Member Has Redeemed Discount
FROM            [1Y_Membership_Anniversary_JourneyEntry] JOURNEY

/* FIND MEMBERS WHO HAVE REDEEMED THEIR DISCOUNT */
INNER JOIN      [Redemption_Log_DE] REDEEM
ON              JOURNEY.MemberID = REDEEM.MemberID
