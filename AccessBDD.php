<?php
include_once("ConnexionPDO.php");

/**
 * Classe de construction des requêtes SQL à envoyer à la BDD
 */
class AccessBDD {
	
    public $login="mediatekdocuments";
    public $mdp="M3D!@T3Kdocuments";
    public $bd="mediatek86";
    public $serveur="localhost";
    public $port="3306";	
    public $conn = null;

    /**
     * constructeur : demande de connexion à la BDD
     */
    public function __construct(){
        try{
            $this->conn = new ConnexionPDO($this->login, $this->mdp, $this->bd, $this->serveur, $this->port);
        }catch(Exception $e){
            throw $e;
        }
    }

    /**
     * récupération de toutes les lignes d'une table
     * @param string $table nom de la table
     * @return lignes de la requete
     */
    public function selectAll($table){
        if($this->conn != null){
            switch ($table) {
                case "livre" :
                    return $this->selectAllLivres();
                case "dvd" :
                    return $this->selectAllDvd();
                case "revue" :
                    return $this->selectAllRevues();
                case "exemplaire" :
                    return $this->selectAllExemplairesRevue();
                case "abonnements":
                    return $this->selectAllAbonnements();
                case "services":
                    return $this->selectAllServices();
    
                default:
                    // cas d'un select portant sur une table simple, avec tri sur le libellé
                    return $this->selectAllTableSimple($table);
            }			
        }else{
            return null;
        }
    }

    /**
     * récupération d'une ligne d'une table
     * @param string $table nom de la table
     * @param string $id id de la ligne à récupérer
     * @return ligne de la requete correspondant à l'id
     */	
    public function selectOne($table, $id){
        if($this->conn != null){
            switch($table){
                case "exemplaire" :
                    return $this->selectAllExemplairesRevue($id);
                case "commande" :
                    return $this->selectAllCommandesByDocument($id);
                case "commandeRevue":
                    return $this->selectAllCommandesByRevue($id);
                default:
                    // cas d'un select portant sur une table simple			
                    $param = array(
                        "id" => $id
                    );
                    return $this->conn->query("select * from $table where id=:id;", $param);					
            }				
        }else{
                return null;
        }
    }

    /**
     * récupération de toutes les lignes de d'une table simple (sans jointure) avec tri sur le libellé
     * @param type $table
     * @return lignes de la requete
     */
    public function selectAllTableSimple($table){
        $req = "select * from $table order by libelle;";		
        return $this->conn->query($req);		
    }

    /**
     * récupération de toutes les lignes de la table Livre et les tables associées
     * @return lignes de la requete
     */
    public function selectAllLivres(){
        $req = "Select l.id, l.ISBN, l.auteur, d.titre, d.image, l.collection, ";
        $req .= "d.idrayon, d.idpublic, d.idgenre, g.libelle as genre, p.libelle as lePublic, r.libelle as rayon ";
        $req .= "from livre l join document d on l.id=d.id ";
        $req .= "join genre g on g.id=d.idGenre ";
        $req .= "join public p on p.id=d.idPublic ";
        $req .= "join rayon r on r.id=d.idRayon ";
        $req .= "order by titre ";		
        return $this->conn->query($req);
    }	

    /**
     * récupération de toutes les lignes de la table DVD et les tables associées
     * @return lignes de la requete
     */
    public function selectAllDvd(){
        $req = "Select l.id, l.duree, l.realisateur, d.titre, d.image, l.synopsis, ";
        $req .= "d.idrayon, d.idpublic, d.idgenre, g.libelle as genre, p.libelle as lePublic, r.libelle as rayon ";
        $req .= "from dvd l join document d on l.id=d.id ";
        $req .= "join genre g on g.id=d.idGenre ";
        $req .= "join public p on p.id=d.idPublic ";
        $req .= "join rayon r on r.id=d.idRayon ";
        $req .= "order by titre ";	
        return $this->conn->query($req);
    }	

    /**
     * récupération de toutes les lignes de la table Revue et les tables associées
     * @return lignes de la requete
     */
    public function selectAllRevues(){
        $req = "Select l.id, l.periodicite, d.titre, d.image, l.delaiMiseADispo, ";
        $req .= "d.idrayon, d.idpublic, d.idgenre, g.libelle as genre, p.libelle as lePublic, r.libelle as rayon ";
        $req .= "from revue l join document d on l.id=d.id ";
        $req .= "join genre g on g.id=d.idGenre ";
        $req .= "join public p on p.id=d.idPublic ";
        $req .= "join rayon r on r.id=d.idRayon ";
        $req .= "order by titre ";
        return $this->conn->query($req);
    }	

    /**
     * récupération de tous les exemplaires d'une revue
     * @param string $id id de la revue
     * @return lignes de la requete
     */
    public function selectAllExemplairesRevue($id){
        $param = array(
                "id" => $id
        );
        $req = "Select e.id, e.numero, e.dateAchat, e.photo, e.idEtat ";
        $req .= "from exemplaire e join document d on e.id=d.id ";
        $req .= "where e.id = :id ";
        $req .= "order by e.dateAchat DESC";		
        return $this->conn->query($req, $param);
    }
    
    /**
     * Sélection de toutes les commandes liées à un document.
     * @param string $idLivreDvd Id du document.
     * @return array Liste des commandes.
     */
    public function selectAllCommandesByDocument($idLivreDvd)
    {
        $param = array(
            "idLivreDvd" => $idLivreDvd
        );
        $req = "SELECT * ";
        $req .= "FROM commande NATURAL JOIN commandedocument NATURAL JOIN suivi ";
        $req .= "WHERE idLivreDvd = :idLivreDvd ";
        $req .= "ORDER BY dateCommande DESC";		
        return $this->conn->query($req, $param);
    }

    /**
     * Sélection de toutes les commandes liées à une revue.
     * @param String $idRevue Id de la revue.
     * @return array Liste des commandes.
     */
    public function selectAllCommandesByRevue($idRevue)
    {
        $param = array(
            "idRevue" => $idRevue
        );
        $req = "SELECT * FROM commande NATURAL JOIN abonnement ";
        $req .= "WHERE idRevue = :idRevue ORDER BY dateCommande DESC";	
        return $this->conn->query($req, $param);    
    }

    /**
     * Permet de récupérer tous les abonnements.
     * @return array Liste des abonnements.
     */
    public function selectAllAbonnements()
    {
        $req = "SELECT * FROM abonnement NATURAL JOIN commande ORDER BY dateFinAbonnement DESC";
        return $this->conn->query($req, []); 
    }

    /**
     * Permet de récupérer tous les services.
     * @return array Liste des services.
     */
    public function selectAllServices()
    {
        return $this->conn->query("SELECT * FROM services");
    }

    /**
     * Permet de récupérer des données dans une table avec un contenu.
     * @param string $table Table dans laquelle effectuer la recherche.
     * @param array $contenu Contenu avec lequel on veut effectuer la recherche.
     */
    public function getWithContenu($table,$contenu)
    {
        if($this->conn != null){
            if($table == "utilisateur")
            {
                return $this->login($contenu);
            }
        }
        else return null;
    }

    /**
     * Permet de vérifier le couple mdp/username dans la BDD.
     * @param array $contenu Contenu de la requête.
     * @return array Paramètres de l'utilisateur.
     */
    public function login($contenu)
    {
        $req = "SELECT * FROM utilisateurs ";
        $req .= "WHERE nom = :nomUtilisateur";

        $param = array(
            "nomUtilisateur" => $contenu["Nom"],
        );

        $query = $this->conn->query($req,$param);

        if($query != [] && password_verify($contenu["Mdp"],$query[0]["mdp"]))
        {
            return $query;
        }
        else
        {
            return null;    
        }
    }



    /**
     * suppresion d'une ou plusieurs lignes dans une table
     * @param string $table nom de la table
     * @param array $champs nom et valeur de chaque champs
     * @return true si la suppression a fonctionné
     */	
    public function delete($table, $champs){
        if($this->conn != null){
            if($table == "commande")
            {
                return $this->deleteCommande($champs);
            }
            if($table == "abonnement")
            {
                return $this->deleteAbonnement($champs);
            }
            // construction de la requête
            $requete = "delete from $table where ";
            foreach ($champs as $key => $value){
                $requete .= "$key=:$key and ";
            }
            // (enlève le dernier and)
            $requete = substr($requete, 0, strlen($requete)-5);   
            return $this->conn->execute($requete, $champs);
        }else{
            return null;
        }	
        }
    
    /**
     * Supprime une commande de document.
     * @param array $champs Informations de la commande à supprimer.
     * @return bool Résultat de la suppression.
     */
    public function deleteCommande($champs)
    {
        $statutCommande = $this->conn->query("SELECT statut FROM suivi WHERE id = :id",["id" => $champs["Id"]])[0]["statut"];
        if($statutCommande == "En cours" || $statutCommande == "Relancée")
        {
            $request = "DELETE FROM commande WHERE id = :id";
            return $this->conn->execute($request,["id" => $champs["Id"]]);
        }
        else return null;
    }

    /**
     * Supprime un abonnement.
     * @param array $champs Informations de l'abonnement à supprimer.
     * @return bool Résultat de la suppression.
     */
    public function deleteAbonnement($champs)
    {
        try
        {
            $this->conn->beginTransaction();

            $req1 = "DELETE FROM abonnement WHERE id = :id";
            $this->conn->execute($req1,["id" => $champs["Id"]]);

            $req2 = "DELETE FROM commande WHERE id = :id";
            $this->conn->execute($req2,["id" => $champs["Id"]]);
    
            return $this->conn->commitTransaction();
    
        }
        catch(PDOException $ex)
        {
            $this->conn->rollbackTransaction();
            return null;
        }

    }

    /**
     * ajout d'une ligne dans une table
     * @param string $table nom de la table
     * @param array $champs nom et valeur de chaque champs de la ligne
     * @return true si l'ajout a fonctionné
     */	
    public function insertOne($table, $champs){

        if($this->conn != null && $champs != null){

            if($table == "commande")
            {         
                return $result = $this->insertCommande($champs);
            }
            else if($table == "commandeRevue")
            {
                return $result = $this->insertCommandeRevue($champs);
            }

            // construction de la requête
            $requete = "insert into $table (";
            foreach ($champs as $key => $value){
                $requete .= "$key,";
            }
            // (enlève la dernière virgule)
            $requete = substr($requete, 0, strlen($requete)-1);
            $requete .= ") values (";
            foreach ($champs as $key => $value){
                $requete .= ":$key,";
            }
            // (enlève la dernière virgule)
            $requete = substr($requete, 0, strlen($requete)-1);
            $requete .= ");";	
                return $this->conn->execute($requete, $champs);		
        }else{
            return null;
        }
    }


    /**
     * Insère une commande de document.
     * @param array $champs Informations de la commande à ajouter.
     */
    public function insertCommande($champs)
    {

        $requetes = [];

        if($this->conn != null && $champs != null)
        {
            try
            {
                $this->conn->beginTransaction();

                $req1 = "INSERT INTO commande ";
                $req1 .= "VALUES (:id,:dateCommande,:montant);";

                $this->conn->execute($req1,[
                    "id"=>$champs["Id"],
                    "dateCommande"=>$champs["DateCommande"],
                    "montant"=>$champs["Montant"]
                ]);

                $req2 = "INSERT INTO commandedocument ";
                $req2 .= "VALUES (:id,:nbExemplaire,:idLivreDvd);";                
                
                $this->conn->execute($req2,[
                    "id"=>$champs["Id"],
                    "nbExemplaire"=>$champs["NbExemplaire"],
                    "idLivreDvd"=>$champs["IdLivreDvd"]
                ]);

                $req3 = "INSERT INTO suivi ";
                $req3 .= "VALUES (:id,:statut)";

                $this->conn->execute($req3,[
                    "id"=>$champs["Id"],
                    "statut"=>$champs["Statut"]
                ]);

                $this->conn->commitTransaction();
                return true;

            }
            catch(PDOException $ex)
            {
                $this->conn->rollbackTransaction();
                return null;
            }
        }
    }

    /**
     * Ajout de la commande d'une revue.
     * @param array $champs Informations de la commande de revue à ajouter.
     * @return bool Résultat de l'insertion.
     */
    public function insertCommandeRevue($champs)
    {

        $requetes = [];

        if($this->conn != null && $champs != null)
        {
            try
            {
                $this->conn->beginTransaction();

                $req1 = "DELETE FROM abonnement ";
                $req1 .= "WHERE idRevue=:idRevue";

                $this->conn->execute($req1,[
                    "idRevue"=>$champs["IdRevue"]
                ]);

                $req2 = "INSERT INTO commande ";
                $req2 .= "VALUES (:id,:dateCommande,:montant);";

                $this->conn->execute($req2,[
                    "id"=>$champs["Id"],
                    "dateCommande"=>$champs["DateCommande"],
                    "montant"=>$champs["Montant"]
                ]);

                $req3 = "INSERT INTO abonnement ";
                $req3 .= "VALUES (:id,:dateFinAbonnement,:idRevue);";                
                
                $this->conn->execute($req3,[
                    "id"=>$champs["Id"],
                    "dateFinAbonnement"=>$champs["DateFinAbonnement"],
                    "idRevue"=>$champs["IdRevue"]
                ]);

                
                return $this->conn->commitTransaction();

            }
            catch(PDOException $ex)
            {
                $this->conn->rollbackTransaction();
                return null;
            }
        }
    }

    
        

    /**
     * modification d'une ligne dans une table
     * @param string $table nom de la table
     * @param string $id id de la ligne à modifier
     * @param array $param nom et valeur de chaque champs de la ligne
     * @return true si la modification a fonctionné
     */	
    public function updateOne($table, $id, $champs){

        
        if($this->conn != null && $champs != null){
            if($table == "suivi")
            {
                return $this->updateSuivi($id,$champs);
            }
            // construction de la requête
            $requete = "update $table set ";
            foreach ($champs as $key => $value){
                $requete .= "$key=:$key,";  
            }
            // (enlève la dernière virgule)
            $requete = substr($requete, 0, strlen($requete)-1);				
            $champs["id"] = $id;
            $requete .= " where id=:id;";				
            return $this->conn->execute($requete, $champs);		
        }else{
            return null;
        }
    }

    /**
     * Modification du suivi d'une commande.
     * 
     * @param string $id Id de la commande à modifier
     * @param array $champs Champs contenant le nouveau suivi de la commande.
     * @return bool Résultat de la requête. 
     */
    public function updateSuivi($id,$champs)
    {
        $statutActuel = $this->conn->query("SELECT statut FROM suivi
        WHERE id=:id",["id" => $id]);

        $statutNouveau = $champs["Statut"];

        if
        (
            $statutActuel != "Réglée" || 
            ($statutActuel == "Livrée" && $statutNouveau == "Réglée") ||
            ($statutActuel == "En cours" && ($statutNouveau == "Livrée" ||   $statutNouveau == "Relancée")) ||
            ($statutActuel == "Relancée" && ($statutNouveau == "Livrée"))    
        )
        {
            $req = "UPDATE suivi SET statut= :statut WHERE id=:id";    

            return $this->conn->execute($req,[
                "statut" => $statutNouveau,  
                "id" => $id
            ]);
        }
        else
        {
            return null;
        }
    }
}