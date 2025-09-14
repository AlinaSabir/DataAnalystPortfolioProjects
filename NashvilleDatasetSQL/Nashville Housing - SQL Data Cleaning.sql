--Cleaning Data in SQL 
--Skills used : CREATE, UPDATE, SELECT, CTE, JOINS, OREDR BY, GROUP BY

Select * from ['Nashville Housing$']

/* Standardize Date Format in SaleDate */

SELECT SaleDate, CONVERT(Date, SaleDate) as SalesDate from ['Nashville Housing$'] 

--UPDATE NashvilleHousing

update ['Nashville Housing$']
set SaleDate = convert(Date, SaleDate)

/*Populate Property Address Data*/

Select * From ['Nashville Housing$'] WHERE PropertyAddress is null
Order by ParcelID

Select a.ParcelID, b.PropertyAddress, b.ParcelID, b.propertyAddress 
From ['Nashville Housing$'] a
JOIN ['Nashville Housing$'] b
ON a.ParcelID = b.parcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress, b.PropertyAddress)
From ['Nashville Housing$'] a
Join ['Nashville Housing$'] b
On a.ParcelID= b.ParcelID
and A.[UniqueID ]= b.[UniqueID ]
Where a.PropertyAddress is null

--Update PropertyAddress column using alias a.

Update a
Set PropertyAddress = isnull (a.PropertyAddress,b.PropertyAddress)
From ['Nashville Housing$'] a
Join ['Nashville Housing$'] b 
On a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Select * from ['Nashville Housing$']

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)

FROM ['Nashville Housing$'] a

JOIN ['Nashville Housing$'] b

ON a.ParcelID = b.parcelID

AND a.[UniqueID ] <> b.[UniqueID ]

WHERE a.PropertyAddress is null

--Breaking Out Address into Individual Columns (Address, City, State)

Select PropertyAddress from ['Nashville Housing$']

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as City
From ['Nashville Housing$']

ALTER table ['Nashville Housing$']
ADD SplitPropertyAddress Nvarchar(255);

Update ['Nashville Housing$']
SET SplitPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE ['Nashville Housing$']
ADD SplitPropertyCity Nvarchar(255);

UPDATE ['Nashville Housing$']
SET SplitPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *

FROM ['Nashville Housing$']

Select OwnerAddress from ['Nashville Housing$']

--OwnerAddress into separate columns for address, city, and state. 

Select PARSENAME(Replace(OwnerAddress,',','.'),3) as OwnerAddress,
PARSENAME(Replace(OwnerAddress,',','.'),2) as City,
PARSENAME(Replace(OwnerAddress,',','.'),1) as States
From ['Nashville Housing$']


--Creating a Split String Function to split the address

ALTER TABLE ['Nashville Housing$']
ADD SplitOwnerAddress Nvarchar(255);
Update ['Nashville Housing$']
SET SplitOwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE ['Nashville Housing$']
ADD SplitOwnerCity Nvarchar(255);
Update ['Nashville Housing$']
SET SplitOwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE ['Nashville Housing$']
ADD SplitOwnerState Nvarchar(255);

Update ['Nashville Housing$']
SET SplitOwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT * FROM ['Nashville Housing$']

--SoldAsVacant column.

SELECT DISTINCT(SoldAsVacant), COUNT (SoldAsVacant)
FROM ['Nashville Housing$']
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
Case When SoldAsVacant= 'Y' then 'Yes'
When SoldAsVacant= 'N' then 'No'
Else SoldAsVacant
End
From ['Nashville Housing$']

UPDATE ['Nashville Housing$']
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes' 
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
SELECT DISTINCT(SoldAsVacant), COUNT (SoldAsVacant)
From ['Nashville Housing$']
Group By SoldAsVacant
Order By 2;

--Check For Duplicates
Select *, ROW_NUMBER() Over 
(Partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY UniqueID
) AS row_num
From ['Nashville Housing$']
Order By ParcelID


Select * From ['Nashville Housing$']

--CTE to view all the duplicates

WITH RowNumCTE AS 
(
    SELECT 
	*,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM ['Nashville Housing$']
)
SELECT * FROM RowNumCTE where row_num >1 
Order by PropertyAddress;

---- There are 104 duplicates.


With RowNumCTE as
(
sELECT 
*,
ROW_NUMBER() Over (
Partition by 
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order by UniqueID
)AS row_num
From ['Nashville Housing$'])

Delete 
From RowNumCTE
where row_num>1

--Delete Unused Column
Select * from ['Nashville Housing$']
Alter table ['Nashville Housing$']
drop column OwnerAddress, TaxDistrict,PropertyAddress

Select * From ['Nashville Housing$']