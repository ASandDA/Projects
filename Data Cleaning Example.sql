/*
Cleaning raw data from Nashville Housing Table.

Please note that there may be duplicate statements. This is due to my looking at the original, then writing a statement to change it (and sometimes checking the new statement in between).
I do this to practice and check myself as much as possible. Feel free to skip the extra stuff if you're trying this code. 

*/

select *
from PortfolioProject..Nashhousing

-- Removing time from the SaleDate column
select SaleDate
from PortfolioProject..Nashhousing

ALTER TABLE PortfolioProject..Nashhousing
ADD SaleDateconverted Date;

Update Nashhousing
SET SaleDateconverted = CONVERT(Date, SaleDate)

select SaleDateconverted
from PortfolioProject..Nashhousing

-- Cleaning Property Address because some rows are null, although the address is linked to a parcel id which may not be null. 
select n1.ParcelID, n2.ParcelID, n1.PropertyAddress, n2.PropertyAddress, ISNULL(n1.PropertyAddress, n2.PropertyAddress)
from PortfolioProject..Nashhousing AS n1
JOIN PortfolioProject..Nashhousing AS n2
	ON n1.ParcelID = n2.ParcelID
	AND n1.[UniqueID ]<> n2.[UniqueID ]
where n1.PropertyAddress IS NULL

UPDATE n1 
SET n1.PropertyAddress = ISNULL(n1.PropertyAddress, n2.PropertyAddress)
from PortfolioProject..Nashhousing AS n1
JOIN PortfolioProject..Nashhousing AS n2
	ON n1.ParcelID = n2.ParcelID
	AND n1.[UniqueID ]<> n2.[UniqueID ]
where n1.PropertyAddress IS NULL

-- Cleaning Address to separate address and city into different columns
select PropertyAddress
from PortfolioProject..Nashhousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City

from PortfolioProject..Nashhousing

ALTER TABLE PortfolioProject..Nashhousing
ADD PropertySplitAddress Nvarchar(255);

Update Nashhousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..Nashhousing
ADD PropertySplitCity Nvarchar(100);

Update Nashhousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select *
from PortfolioProject..Nashhousing

--Owner Address also needs to be split by address, city, and state. Will use Parse method this time, which means changing the commas to periods.
select OwnerAddress
from PortfolioProject..Nashhousing

select PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

from PortfolioProject..Nashhousing

ALTER TABLE PortfolioProject..Nashhousing
ADD OwnerSplitAddress Nvarchar(255);

Update Nashhousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE PortfolioProject..Nashhousing
ADD OwnerSplitCity Nvarchar(100);

Update Nashhousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE PortfolioProject..Nashhousing
ADD OwnerSplitState Nvarchar(100);

Update Nashhousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

select *
from PortfolioProject..Nashhousing

-- Changing the SoldAsVacant column to be uniformed with Yes and No. (Some rows have Y, some have Yes, etc...)
Select Distinct(SoldAsVacant)
from PortfolioProject..Nashhousing

select SoldAsVacant,
CASE WHEN
	SoldAsVacant = 'Y'
	THEN 'Yes'
	WHEN SoldAsVacant = 'N'
	THEN 'No'
	ELSE SoldAsVacant
	END AS SoldAsVacantUpdated
from PortfolioProject..Nashhousing

Update Nashhousing
SET SoldAsVacant = CASE WHEN
	SoldAsVacant = 'Y'
	THEN 'Yes'
	WHEN SoldAsVacant = 'N'
	THEN 'No'
	ELSE SoldAsVacant
	END

--Delete the Columns we no longer need after our revisions above. NOTE: ALWAYS be careful before deleting from the data!!
ALTER TABLE PortfolioProject..Nashhousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

Select *
from PortfolioProject..Nashhousing