SELECT 
    SUBSTRING(O.ORDER_REF, 3) AS OrderReference,
    DATE_FORMAT(O.ORDER_DATE, '%M %d, %Y') AS OrderDate,
    UPPER(S.SUPP_NAME) AS SupplierName,
    FORMAT(O.TOTAL_AMOUNT, '##,###,###.00') AS OrderTotalAmount,
    O.STATUS AS OrderStatus,
    GROUP_CONCAT(I.Invoice_Ref SEPARATOR '|') AS InvoiceReferences
FROM 
    ORDERS O
INNER JOIN 
    SUPPLIERS S ON O.SUPP_ID = S.SUPP_ID
LEFT JOIN 
    INVOICES I ON O.ORDER_ID = I.ORDER_ID
WHERE 
    O.TOTAL_AMOUNT = (
        SELECT 
            DISTINCT TOTAL_AMOUNT
        FROM 
            ORDERS
        ORDER BY 
            TOTAL_AMOUNT DESC
        LIMIT 1 OFFSET 1
    )
GROUP BY 
    O.ORDER_ID
LIMIT 1;
