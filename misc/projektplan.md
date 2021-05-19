# Projektplan

## 1. Projektbeskrivning (Beskriv vad sidan ska kunna göra).

På sidan ska man kunna skapa ett konto där man kan skapa karaktärer som man ska använda för rollspel. Karaktärerna ska ha porträtt, olika attribut och namn. Dessutom ska karaktärerna kunna äga utrustning, bl.a vapen. Allt som karaktärerna äger ska dessutom ha egna namn, bilder och attribut.

## 2. Vyer (visa bildskisser på dina sidor).

![login](login.png)

![your-characters](yourcharacters.png)

## 3. Databas med ER-diagram (Bild på ER-diagram).

![ER](ER-diagram.png)

## 4. Arkitektur (Beskriv filer och mappar - vad gör/innehåller de?).

I misc mappen ligger alla bilder, så som ER-Diagram och skiss på sidan, samt projektplanen och bedömings anvisningen. 

I public mappen ligger en css map där style.css filen ligger. I style.css är sidans enkla css programmerad.

Enligt MVC har jag en views map där alla slim filer ligger. Slim filerna bestämmer strukturen på sidorna som routsen leder till på hemsidan. Alla sidor utgår från layout.slim, där en annan slim fil läggs på under. I slim filerna finns det forms som är både POST och GET. Utöver det finns det enkla saker som text på sidan och listor.

Jag har två ruby filer enligt MVC, en vid namn app.rb och en vid namn model.rb. Model.rb tar hand om all interaktion med DB (databasen). Inloggning och registrering hanteras här. Den tar även hand om CRUD av entiteterna i databasen. Entiteter och attribut kan skapas, läsas, uppdateras och raderas. Ett exempel är entiteten utrustning som har attributet skada, i model.rb kan utrustningens skada ändras. App.rb hanterar istället routes och vilken sida de leder till. Alla POST och GET forms hanteras även här där funktioner från model.rb används med require_relative. Vad vem som är inloggad kan göra på sidan hanteras även här, du kan t.ex inte ändra på något om du inte är inloggad och du kan inte ändra på någon annans atribut och/eller entiteter.
