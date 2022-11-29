import java.time.LocalDate;
import java.util.*;

public class Main{
	public static int min_artist = 1;
	public static int max_artist = 61;
	public static int nb_artist = max_artist - min_artist;
	public static int min_producer = 1;
	public static int max_producer = 21;
	public static int nb_actor = 30;
	public static int nb_musician = 40;
	public static List<Integer> listActor = new LinkedList<Integer>();
	public static List<Integer> listMusician = new LinkedList<Integer>();

	public static int nb_critic = 200;

	//Project
	public static int min_project = 1;
	public static int max_project = 150;
	public static int nb_project = max_project-min_project;
	public static int low_Type_Event = 1;
	public static int high_Type_Event = 3;
	public static int low_profit = 10000;
	public static int high_profit = 100000000;
	public static List<Integer> listProject = new LinkedList<Integer>();

	//ContractAA
    public static LinkedList<Integer> contracted = new LinkedList<Integer>();
	public static int nb_contractAA = 60;
	public static int lowPercent = 5;
	public static int highPercent = 40;
	public static int lowTypeC = 0;
	public static int highTypeC = 1;

	//Demand
	public static int min_demand = 1;
	public static int max_demand = 100;
	public static int nb_demand = max_demand-min_demand;

	//Payment
	public static int nb_payment = 50;
	public static int lowCAA = 1;
    public static int highCAA = 40;
    public static int lowAmountPayment = 100;
    public static int highAmountPayment = 10000;
    //Accounting
    public static int min_accounting = 1;
    public static int nb_accounting = 100-min_accounting;
    //ContactPA
    public static int min_CPA = 1;
    public static int nb_CPA = 30 - min_CPA;
    public static int lowEarning = 10000;
    public static int highEarning = 100000;
    public static int lowProfit_sharing = 5;
    public static int highProfit_sharing = 30;
    public static int lowClause = 10000;
    public static int highClause = 10000000;
    public static int lowClause_profit = 1000;
    public static int highClause_profit = 1000000;

	//Profile
	public static int min_profile = 1;
	public static int max_profile = 80;
	public static int nb_profile = max_profile-min_profile;
	public static int low_critic = 1;
	public static int high_critic = 7;

    public static void main(String args[]) {
    	String ac = Actor();
        String mus = Musician();
        String lang = Language();
        String crit = Critic();
        String cAA = ContractAA();
        String prof = Profile();
        String proj = Project();
	    String dem = Demand();
        String cPA = ContractPA();

        String pay = Payment();
        String acco = Accounting();

        System.out.println(artist_prod());

    	System.out.println(ac);
        System.out.println(mus);
        System.out.println(lang);
        System.out.println(crit);
        System.out.println(cAA);
        System.out.println(prof);
        System.out.println(proj);
        System.out.println(dem);
        System.out.println(cPA);

        //System.out.println(acco);
        //System.out.println(pay);
    }

    public static String Actor() {
    	String res = "INSERT INTO Actor(artist_id)\n";
    	res = res + "VALUES ";
        for (int i = 0; i < nb_actor; i++) {
        	int rActor;
        	do{
        		rActor = randomNumber(min_artist,max_artist+1);
        	}while(listActor.contains(rActor));

        	listActor.add(rActor);

            int artist_id = rActor;
            //listMusician.get(rMusician);

            res = res + "\t(" + artist_id +")";
            if(i==nb_actor-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
        }
        return res;
    }


    // INSERT INTO Musician(musician_id, artist_id, style)
    public static String Musician() {
        List<String> listStyleMusic = Arrays.asList("Rock", "Pop", "Jazz", "Soul", "Rap", "Folk", "Punk", "Metal", "Hip-hop", "Rnb", "Blues", "Reggae", "Electro", "Funk", "Country");

    	String res = "INSERT INTO Musician(musician_id, artist_id, style)\n";
        res = res +"VALUES ";
        for (int i = 0; i < nb_musician; i++) {
        	int rMusician;
        	do {
        		rMusician = randomNumber(min_artist,max_artist+1);
        	}while(listMusician.contains(rMusician));

    		listMusician.add(rMusician);

    		int artist_id = rMusician;
            //listMusician.get(rMusician);

            int rStyleMusic = (int) (Math.random() * listStyleMusic.size());

            String style = listStyleMusic.get(rStyleMusic);

            res = res + "\t(" +i +", "+ artist_id + "," + "'" + style + "')";
            if(i==nb_musician-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
        }return res;
    }

    // INSERT INTO Critic(artist_id, remarque)
    public static String Critic() {
        String res = "INSERT INTO Critic(artist_id, remarque)\n";
        res = res + "VALUES ";
        int lowRemarque = 0;
        int highRemarque = 10;
        for (int i = 0; i < nb_critic; i++) {

            int rArtist = randomNumber(min_artist, max_artist+1);

            int artist_id = rArtist;

            int remarque = randomNumber(lowRemarque, highRemarque);

           res = res + "\t(" + artist_id + "," + remarque + ")";
           if(i==nb_critic-1) {
           	res = res + ";\n";
           }else {
           	res = res + ",\n";
           }
        }
        return res;
    }

    // INSERT INTO Language(actor_id, country)
    public static String Language() {

    	List<String> listCountry = Arrays.asList("Anglais", "Mandarin", "Hindi", "Espagnol", "Arabe", "Bengali", "Français", "Russe", "Portugais", "Ourdou");

    	String[][] l = new String[nb_artist][listCountry.size()];
    	for(int a = 0;a < l.length;a++) {
    		for(int b = 0;b<l[a].length;b++) {
    			l[a][b] = "";
    		}
    	}
        String res = "INSERT INTO Language(actor_id, country)\n";
        res = res + "VALUES ";
        for (int i = 0; i < listActor.size(); i++) {
        	int rActor;
        	int rCountry;
        	String country="";
        	boolean pairValid = false;
        	do {
        		do {
        			rActor = randomNumber(min_artist,max_artist);
        		}while(!listActor.contains(rActor));

        		//rActor = numero de l'acteur

            	rCountry = (int) (Math.random() * listCountry.size());
            	country = listCountry.get(rCountry);
            	if(l[rActor-1][rCountry].equals("")) {
            		l[rActor-1][rCountry] = country;
            		pairValid = true;
            	}
        	}while(!pairValid);



            res = res + "\t(" + rActor+ ",'" + country + "')";
            if(i==listActor.size()-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
        }
        return res;
    }

    //INSERT INTO public.project(project_id, type_project, date_project, profit_project, description_project)

    public static String Project() {
        int project_id = min_project;

        List<String> listDescriptionRole = Arrays.asList("Premier Role", "Second Role", "Figurant");
        List<String> listFestival = Arrays.asList("Paris", "Bordeaux", "Marseille", "Rome", "Dublin", "Madrid", "Barcelone", "Valence", "Porto", "Lisbonne", "Londres", "Geneve", "Vienne", "Ibiza", "Lille");
        List<String> listAlbum = Arrays.asList("Participation Album", "Creation album entier", "Écriture paroles");

        String res = "INSERT INTO public.project(project_id, type_project, date_project, profit_project, description_project)\n";
        res = res + "VALUES ";

        for (int i = 0; i < nb_project; i++) {

            int rDescriptionRole = (int) (Math.random() * listDescriptionRole.size());

            int rFestival = (int) (Math.random() * listFestival.size());

            int rAlbum = (int) (Math.random() * listAlbum.size());

            int type_project = randomNumber(low_Type_Event, high_Type_Event+1);
            listProject.add(type_project);
            LocalDate DateProject = createRandomDate(2020, 1, 1, 2028, 12, 28);

            int profit_project = randomNumber(low_profit, high_profit+1);

            res = res + "\t(" + project_id + "," + type_project + ",'" + DateProject.getYear() + "-" + DateProject.getMonthValue() + "-" + DateProject.getDayOfMonth() + "'," + profit_project;

            if (type_project == 1) {
            	res = res + ",'Role: " + listDescriptionRole.get(rDescriptionRole) + "')";
            } else if (type_project == 2) {
            	res = res + ",'Festival: " + listFestival.get(rFestival) + "')";
            } else if (type_project == 3) {
            	res = res + ",'Album: " + listAlbum.get(rAlbum) + "')";
            }
            if(i==nb_project-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            project_id++;
        }
        return res ;
    }

    //INSERT INTO Contract_Agency_Artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage)

    public static String ContractAA() {
        int contract_aa_id = 1;

        String res = "INSERT INTO Contract_Agency_Artist(contract_aa_id, artist_id, type_contract, start_date_contract_aa, end_date_contract_aa, percentage)\n";
        res = res + "VALUES ";

        for (int i = 0; i < nb_contractAA; i++) {

            int percentage = randomNumber(lowPercent, highPercent+1);

            int type_contract = randomNumber(lowTypeC, highTypeC+1);

            int artist_id;
            do {
            	artist_id = randomNumber(min_artist, max_artist+1);
            }while(contracted.contains(artist_id));
            contracted.add(artist_id);

            res = res + "\t(" + contract_aa_id + "," + artist_id + "," ;
            if (type_contract == 0) {

                LocalDate startDate = createRandomDate(2010, 1, 1, 2022, 12, 28);

                LocalDate endDate = createRandomDate(2022, 8, 27, 2026, 12, 28);

                res = res +"TRUE"+ ",'" + startDate.getYear() + "-" + startDate.getMonthValue() + "-" + startDate.getDayOfMonth() + "','" + endDate.getYear() + "-" + endDate.getMonthValue() + "-" + endDate.getDayOfMonth() + "'," + percentage + ")";

            } else {
                res = res +"FALSE"+ ",NULL,NULL," + percentage + ")";
            }
            if(i==nb_contractAA-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            contract_aa_id++;
        }
        return res;
    }

    //INSERT INTO Demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand)

    public static String Demand() {
        int demand_id = min_demand;
        String res = "INSERT INTO Demand(demand_id, producer_id, project_id, profile_id, start_date_demand, end_date_demand)\n";
        res = res + "VALUES ";

        for (int i = 0; i < nb_demand; i++) {

            int producer_id = randomNumber(min_producer, max_producer);

            int project_id = randomNumber(min_project, max_project);

            int profile = randomNumber(min_profile, max_profile);

            LocalDate startDateDemand = createRandomDate(2021, 11, 1, 2022, 12, 28);;

            LocalDate endDateDemand = createRandomDate(startDateDemand.getYear(), startDateDemand.getMonthValue(), startDateDemand.getDayOfMonth(), 2026, 12, 28);


            res = res + "\t(" + demand_id + "," + producer_id + "," + project_id + "," + profile + ",'" + startDateDemand.getYear() + "-" + startDateDemand.getMonthValue() + "-" + startDateDemand.getDayOfMonth() + "','" + endDateDemand.getYear() + "-" + endDateDemand.getMonthValue() + "-" + endDateDemand.getDayOfMonth() + "')";
            if(i==nb_demand-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            demand_id++;
        }return res;
    }

    //INSERT INTO Payment(payment_id, contract_pa_id, amount_payment, date_payment)

    public static String Payment() {
        int payment_id = 1;
        String res = "INSERT INTO Payment(payment_id, contract_pa_id, amount_payment, date_payment)\n";
        res = res + "VALUES ";

        for (int i = 0; i < nb_payment; i++) {

            int contract_pa_id = randomNumber(lowCAA, highCAA+1);

            int amount_payment = randomNumber(lowAmountPayment, highAmountPayment+1);

            LocalDate datePayment = createRandomDate(2010, 11, 11, 2026, 12, 28);

            res = res + "\t(" + payment_id + "," + contract_pa_id + "," + amount_payment + ",'" + datePayment.getYear() + "-" + datePayment.getMonthValue() + "-" + datePayment.getDayOfMonth() + "')";
            if(i==nb_payment-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            payment_id++;
        }
        return res;
    }

    // INSERT INTO Accounting(accounting_id, payment_id, contract_aa_id, amount, costs)

    public static String Accounting() {
        int t = min_accounting;
        String res = "INSERT INTO Accounting(accounting_id, payment_id, contract_aa_id, amount, costs)\n";
        res = res + "VALUES ";
        for (int i = 0; i < nb_accounting; i++) {

            res = res + "\t(" + t + "," + t + "," + 1 + "," + 10000000 + "," + 10000000 + "),";
            if(i==nb_accounting-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            t++;
        }
        return res;
    }

    //INSERT INTO public.contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit)

    public static String ContractPA() {
        int contract_pa_id = min_CPA;
        String res = "INSERT INTO public.contract_producer_artist(contract_pa_id, demand_id, artist_id, earning, profit_sharing, start_date_contract_pa, end_date_contract_pa, clause, clause_profit)\n";
        res = res + "VALUES ";
        for (int i = 0; i < nb_CPA; i++) {

            int demand_id = randomNumber(min_demand, max_demand);

            int index = randomNumber(min_artist, max_artist);

            int artist_id = index;

            int earning = randomNumber(lowEarning, highEarning+1);

            int profit_sharing = randomNumber(lowProfit_sharing, highProfit_sharing+1);

            LocalDate startDateContract_PA = createRandomDate(2010, 1, 1, 2022, 12, 28);

            LocalDate endDateContract_PA = createRandomDate(2022, 8, 1, 2026, 12, 28);

            int clause = randomNumber(lowClause, highClause);

            int clause_profit = randomNumber(lowClause_profit, highClause_profit);

            res = res +"\t(" + contract_pa_id + "," + demand_id + "," + artist_id + "," + earning + "," + profit_sharing + ",'" + startDateContract_PA.getYear() + "-" + startDateContract_PA.getMonthValue() + "-" + startDateContract_PA.getDayOfMonth() + "','" + endDateContract_PA.getYear() + "-" + endDateContract_PA.getMonthValue() + "-" + endDateContract_PA.getDayOfMonth() + "'," + clause + ',' + clause_profit + ")";
            if(i==nb_CPA-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            contract_pa_id++;
        }
        return res;
    }

    // INSERT INTO public.profile(profile_id, language, critic, style)
    public static String Profile() {
        int profile_id = min_profile;
        String res = "INSERT INTO public.profile(profile_id, language, critic, style)\n";
        res = res + "VALUES ";

        List<String> listCountry = Arrays.asList("Anglais", "Mandarin", "Hindi", "Espagnol", "Arabe", "Bengali", "Français", "Russe", "Portugais", "Ourdou");

        List<String> listStyleMusic = Arrays.asList("Rock", "Pop", "Jazz", "Soul", "Rap", "Folk", "Punk", "Metal", "Hip-hop", "Rnb", "Blues", "Reggae", "Electro", "Funk", "Country");


        for (int i = 0; i < nb_profile; i++) {

            int critic = randomNumber(low_critic, high_critic+1);
            int role = randomNumber(low_Type_Event, high_Type_Event+1);

            if (role == 1) {

                int rCountry = (int) (Math.random() * listCountry.size());

                String country = listCountry.get(rCountry);

                res = res +"\t(" + profile_id +",'" + country + "'," + critic + ",null)";
            } else {
                int rStyleMusic = (int) (Math.random() * listStyleMusic.size());

                String style = listStyleMusic.get(rStyleMusic);

                res = res +"\t(" + profile_id +",null," + critic + ",'" + style + "')";
            }

            if(i==nb_profile-1) {
            	res = res + ";\n";
            }else {
            	res = res + ",\n";
            }
            profile_id++;
        }
        return res;
    }

    public static int createRandomIntBetween(int start, int end) {
        return start + (int) Math.round(Math.random() * (end - start));
    }

    public static LocalDate createRandomDate(int startYear, int startMonth, int startDay, int endYear, int endMonth, int endDay) {
    	int day = createRandomIntBetween(startDay+1, 28);
        int month = createRandomIntBetween(startMonth, 12);
        int year = createRandomIntBetween(startYear, endYear);
        return LocalDate.of(year, month, day);
    }
    //min inclus max exclus
    public static int randomNumber(int min, int max) {
    	Random random = new Random();
    	int value = random.nextInt(max - min) + min;
    	return value;
    }
    public static String artist_prod() {
    	String res = "INSERT INTO Artist(artist_id, name_artist, firstname_artist, birthday_artist)\r\n"
    			+ "VALUES (1, 'CLEMENT', 'Fabien', '1981-05-15'),\r\n"
    			+ "       (2, 'NOEL', 'Gérard', '1986-11-13'),\r\n"
    			+ "       (3, 'LECLERQ', 'Lucas', '1979-07-02'),\r\n"
    			+ "       (4, 'BRUN', 'Valentin', '1983-10-16'),\r\n"
    			+ "       (5, 'ROBIN', 'Hervé', '1989-07-21'),\r\n"
    			+ "       (6, 'LUCAS', 'Nicolas', '2001-05-23'),\r\n"
    			+ "       (7, 'MENARD', 'Antoine', '1990-01-01'),\r\n"
    			+ "       (8, 'BARRETTE', 'Edouard', '1956-11-11'),\r\n"
    			+ "       (9, 'BONNEVILLE', 'La Roux', '1976-02-28'),\r\n"
    			+ "       (10, 'TRUDEAU', 'Fabien', '1979-04-26'),\r\n"
    			+ "       (11, 'BISSON', 'Gaston', '1960-10-11'),\r\n"
    			+ "       (12, 'VALLEE', 'Tabor', '1964-02-12'),\r\n"
    			+ "       (13, 'BOLDUC', 'Courtland', '1992-06-01'),\r\n"
    			+ "       (14, 'DUCLOS', 'Victorine', '1989-12-04'),\r\n"
    			+ "       (15, 'GAMELIN', 'Evrard', '1988-08-02'),\r\n"
    			+ "       (16, 'MARTINEAU', 'Curtis', '1957-10-31'),\r\n"
    			+ "       (17, 'DUPUIS', 'Armand', '1937-06-25'),\r\n"
    			+ "       (18, 'BERTHIAUME', 'Fleur', '2017-04-30'),\r\n"
    			+ "       (19, 'METIVIER', 'Eliot', '2005-04-24'),\r\n"
    			+ "       (20, 'DIONNE', 'Mavise', '1993-12-06'),\r\n"
    			+ "       (21, 'SAUVE', 'Caroline', '1948-10-24'),\r\n"
    			+ "       (22, 'GAILLARD', 'Rive', '1951-01-22'),\r\n"
    			+ "       (23, 'FOUCAULT', 'Alexis', '1957-09-09'),\r\n"
    			+ "       (24, 'ROCHELEAU', 'Yves', '1957-04-25'),\r\n"
    			+ "       (25, 'GUERIN', 'Alexandre', '1983-02-10'),\r\n"
    			+ "       (26, 'LAVALLEE', 'Emmanuelle', '2004-06-28'),\r\n"
    			+ "       (27, 'SALOIS', 'Anne', '1994-08-04'),\r\n"
    			+ "       (28, 'BEAUCHAMP', 'Elisabeth', '1967-04-17'),\r\n"
    			+ "       (29, 'GUIMOND', 'Aymon', '1958-03-23'),\r\n"
    			+ "       (30, 'DUFOUR', 'Donatien', '2006-06-29'),\r\n"
    			+ "       (31, 'SIMARD', 'Sargent', '1943-02-05'),\r\n"
    			+ "       (32, 'MARIER', 'Pascaline', '2000-04-24'),\r\n"
    			+ "       (33, 'VACHON', 'Jeanette', '1998-02-16'),\r\n"
    			+ "       (34, 'CHASTAIN', 'Aloin', '1961-08-20'),\r\n"
    			+ "       (35, 'LEVESQUE', 'Senapsus', '1947-09-09'),\r\n"
    			+ "       (36, 'DAGENAIS', 'Victoire', '2006-10-01'),\r\n"
    			+ "       (37, 'LEROUX', 'Auda', '1979-05-19'),\r\n"
    			+ "       (38, 'CLAVET', 'Aubin', '2011-08-14'),\r\n"
    			+ "       (39, 'AUBE', 'Martine', '1953-10-10'),\r\n"
    			+ "       (40, 'GIROUX', 'Belisarda', '1984-09-11'),\r\n"
    			+ "       (41, 'DU TRIEUX', 'Zdenek', '2015-12-27'),\r\n"
    			+ "       (42, 'BRIARD', 'Audrey', '1993-04-18'),\r\n"
    			+ "       (43, 'DESJARDINS', 'Martin', '1964-04-08'),\r\n"
    			+ "       (44, 'JOLY', 'Orlene', '1987-01-27'),\r\n"
    			+ "       (45, 'ROCHELEAU', 'Blanche', '2002-07-06'),\r\n"
    			+ "       (46, 'CADIEUX', 'Avenall', '1976-09-06'),\r\n"
    			+ "       (47, 'MIGUEL', 'William', '1946-11-12'),\r\n"
    			+ "       (48, 'JALBERT', 'Pascal', '2014-04-25'),\r\n"
    			+ "       (49, 'GUAY', 'Tristan', '1971-02-16'),\r\n"
    			+ "       (50, 'GANDBOIS', 'Methena', '2011-04-06'),\r\n"
    			+ "       (51, 'COVILLON', 'Nouel', '1947-06-18'),\r\n"
    			+ "       (52, 'GREGOIRE', 'Timothée', '1996-11-10'),\r\n"
    			+ "       (53, 'CHARRETTE', 'Arridano', '1946-05-02'),\r\n"
    			+ "       (54, 'LIZOTTE', 'Andre', '2001-10-04'),\r\n"
    			+ "       (55, 'SAVARD', 'Laurence', '2002-09-11'),\r\n"
    			+ "       (56, 'LAPIERRE', 'Aleron', '2008-10-01'),\r\n"
    			+ "       (57, 'MOREAU', 'Alphonse', '2015-03-17'),\r\n"
    			+ "       (58, 'PANETIER', 'Aime', '1964-12-04'),\r\n"
    			+ "       (59, 'METHOT', 'Albert', '1978-03-24'),\r\n"
    			+ "       (60, 'JEAN', 'Pierre', '1995-09-01'),\r\n"
    			+ "       (61, 'BARBIER', 'Roux', '1940-04-08');\r\n"
    			+ "\r\n"
    			+ "INSERT INTO Producer(producer_id, name_producer, firstname_producer)\r\n"
    			+ "VALUES (1, 'GAULIN', 'Morgana'),\r\n"
    			+ "       (2, 'DAVIS', 'Cham'),\r\n"
    			+ "       (3, 'MCGREW', 'Ralph'),\r\n"
    			+ "       (4, 'BARRY', 'Joseph'),\r\n"
    			+ "       (5, 'PATRICK', 'Scott'),\r\n"
    			+ "       (6, 'KING', 'Maria'),\r\n"
    			+ "       (7, 'BAND', 'Charles'),\r\n"
    			+ "       (8, 'COPPOLA', 'Ford'),\r\n"
    			+ "       (9, 'HURD', 'Anne'),\r\n"
    			+ "       (10, 'NAGATA', 'Masaichi'),\r\n"
    			+ "       (11, 'FONG', 'Mona'),\r\n"
    			+ "       (12, 'SPIELBERG', 'Steven'),\r\n"
    			+ "       (13, 'BELOLO', 'Henri'),\r\n"
    			+ "       (14, 'GODRICH', 'Nigel'),\r\n"
    			+ "       (15, 'KEN', 'Scott'),\r\n"
    			+ "       (16, 'MARTIN', 'Georges'),\r\n"
    			+ "       (17, 'SPECTOR', 'Jones'),\r\n"
    			+ "       (18, 'EMERICK', 'GEOFF'),\r\n"
    			+ "       (19, 'DREAM', 'Charles'),\r\n"
    			+ "       (20, 'RUBIN', 'Rick'),\r\n"
    			+ "       (21, 'William', 'Jones');\r\n"
    			;
    	return res;
    }
}