# Layoffs Data Analysis Project 

**Key Goals?** 
I cleaned up a messy dataset of layoffs of companies to make it reliable for analysis.  I removed duplicates, fixed typos, and filled in missing values, preparing it for analysis, and identifying trends, in layoffs  by company, industry and country.

### **Data cleaning steps:**  

1. **Removing Duplicates**
   Created a staging table (`layoffs_staging2`) to preserve raw data. (Made a backup of the raw data) 
   Spotted repeat entries (like two entries for "Casper") and deleted them.  
        
2. **Standardised messy details**  
   Fixed inconsistent categories  
   Merged *"cryptocurrency"* and *"crypto"* into one category: **"crypto"**.  
   Cleaned country names (e.g., *"United States."* became *"United States"*).  
   Trimmed spaces in company names (so "Google " became "Google").  

3. **Handled missing data**  
   Replaced blank *industry* fields with `NULL` to avoid confusion.  
   Filled in missing industries using existing data (e.g., used "Airbnb’s" industry for its missing entries).  
   Deleted 4 rows where layoff numbers were missing  

4. **Fixed dates**  
   Turned text-based dates (like *"3/12/2022"*) into proper `DATE` format for smoother analysis.  

## **How to run this project**  

1. **download the files**  
   **Dataset**: (Data/layoffs.csv)   
   **SQL scripts**: SQL-Scripts/Data_Cleaning.sql and Data_Exploration.sql.  

2. **Run the SQL scripts** *(in this order)*  
   **First**: `Data_Cleaning.sql` – cleaning the raw data.  
   **Then**: `Data_Exploration.sql` – digs into trends (like "Which industries laid off the most?").  

## **What I discovered**   

**12 duplicate rows** were removed (e.g., "Casper" was listed twice).  
**"Crypto"** became the standard name for all crypto-related industries.  
**4 incomplete rows** were removed – no half-baked data here  

## Key Insights 
**Biggest layoffs**: Amazon (18,000 employees in 2022).
**Peak layoffs**: March 2022.
