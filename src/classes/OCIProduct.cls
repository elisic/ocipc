public interface OCIProduct {
     ID getID();
     String getCode(); //name
     String getCategory();
     String getName(); //description
     String getDetail();
     Integer getLeadTime();
     String getLeadTimeDisplay();
     String getDescription(); // long description
     String getManufacturerProductNumber();
     String getPictureDocumentID();
     Decimal getOriginal_price();
     String getOriginal_priceDisplay();
     Decimal getNegotiated_price();
     String getNegotiated_priceDisplay();
     Decimal getPrice();
     String getPriceDisplay();
     Integer getPriceUnit();
     String getCurrencyDisplay();
     String getUnitDisplay();
     String getUnitISO();
     String getUNSPSCcode();
     String getUNSPSC(); 
     // calculated
     boolean getApproved();
     String getQuantity();
     void setQuantity(String value);
     Long getCost();
     Long getSaving();
}