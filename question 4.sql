SELECT 
    SUBSTRING(O.ORDER_REF, 3) AS OrderReference,
    DATE_FORMAT(O.ORDER_DATE, '%b-%Y') AS OrderPeriod,
    CONCAT(
        upper(SUBSTRING_INDEX(S.SUPP_NAME, ' ', 1)),
        ' ',
        lower(SUBSTRING_INDEX(S.SUPP_NAME, ' ', -1))
    ) AS SupplierName,
    FORMAT(O.TOTAL_AMOUNT, '##,###,###.00') AS OrderTotalAmount,
    O.STATUS AS OrderStatus,
    GROUP_CONCAT(DISTINCT I.Invoice_Ref ORDER BY I.Invoice_Ref) AS InvoiceReference,
    FORMAT(SUM(I.Amount), '##,###,###.00') AS InvoiceTotalAmount,
    CASE 
        WHEN COUNT(DISTINCT I.Status) = 1 AND MAX(I.Status) = 'Paid' THEN 'OK'
        WHEN COUNT(DISTINCT I.Status) = 1 AND MAX(I.Status) = 'Pending' THEN 'To follow up'
        ELSE 'To verify'
    END AS Action
FROM 
    ORDERS O
JOIN 
    SUPPLIERS S ON O.SUPP_ID = S.SUPP_ID
LEFT JOIN 
    INVOICES I ON O.ORDER_ID = I.ORDER_ID
GROUP BY 
    O.ORDER_ID
ORDER BY 
    O.ORDER_DATE DESC;
