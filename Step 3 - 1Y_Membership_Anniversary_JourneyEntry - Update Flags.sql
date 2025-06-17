/* UPDATING JOURNEY ENTRY DE TO FLAG MEMBERS WHO HAVE REDEEMED */

SELECT          JOURNEY.MemberID,
                1 AS HasClaimedDiscount -- Flag Indicating Member Has Redeemed Discount (1 = True)
FROM            [1Y_Membership_Anniversary_JourneyEntry] JOURNEY

/* JOINING WITH REDEMPTION LOG TO IDENTIFY ONLY MEMBERS WHO HAVE REDEEMED */
INNER JOIN      [Redemption_Log_DE] REDEEM -- Members Who Have Already Redeemed Discount
ON              JOURNEY.MemberID = REDEEM.MemberID
