DECLARE @ResultString NVARCHAR(MAX);

SELECT @ResultString
    =
(
    SELECT CHAR(13) + CHAR(10) + data_type + ' ' + column_name + ' { get; set; }'
    FROM
    (
        SELECT CASE
                   WHEN c.DATA_TYPE IN ( 'char', 'varchar', 'nvarchar', 'ntext' ) THEN
                       CASE
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL
                                AND IS_NULLABLE = 'NO' THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX))
                               + '), Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public string'
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX)) + ')]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public string'
                           WHEN IS_NULLABLE IS NOT NULL THEN
                               '[Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4) + CHAR(13)
                               + CHAR(10) + 'public string'
                           ELSE
                               'public string'
                       END
                   WHEN c.DATA_TYPE IN ( 'image' ) THEN
                       CASE
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL
                                AND IS_NULLABLE = 'NO' THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX))
                               + '), Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public byte[]'
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX)) + ')]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public byte[]'
                           WHEN IS_NULLABLE IS NOT NULL THEN
                               '[Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4) + CHAR(13)
                               + CHAR(10) + 'public byte[]'
                           ELSE
                               'public string'
                       END
                   WHEN c.DATA_TYPE IN ( 'int', 'tinyint' ) THEN
                       CASE
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL
                                AND IS_NULLABLE = 'NO' THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX))
                               + '), Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public int'
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX)) + ')]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public int'
                           WHEN IS_NULLABLE IS NOT NULL THEN
                               '[Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4) + CHAR(13)
                               + CHAR(10) + 'public int'
                           ELSE
                               'public int'
                       END
                   WHEN c.DATA_TYPE IN ( 'datetime' ) THEN
                       CASE
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL
                                AND IS_NULLABLE = 'NO' THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX))
                               + '), Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public DateTime'
                           WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN
                               '[MaxLength(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(MAX)) + ')]' + SPACE(4)
                               + CHAR(13) + CHAR(10) + 'public DateTime'
                           WHEN IS_NULLABLE IS NOT NULL THEN
                               '[Required(ErrorMessage = "The ' + COLUMN_NAME + ' is required")]' + SPACE(4) + CHAR(13)
                               + CHAR(10) + 'public DateTime'
                           ELSE
                               'public int'
                       END
                   ELSE
                       'public ' + c.DATA_TYPE
               END AS data_type,
               c.column_name
        FROM information_schema.columns c
        WHERE TABLE_CATALOG = 'Northwind'
              AND TABLE_SCHEMA = 'dbo'
              AND TABLE_NAME = 'Employees'
    ) AS [data]
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)')

PRINT 'public class Employees {' + @ResultString + '
}';
