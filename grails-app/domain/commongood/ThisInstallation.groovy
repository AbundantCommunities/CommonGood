package commongood

// This table has exactly one row that describes the installation of our webapp on this server.
class ThisInstallation {
    String name
    String logo

    // Starts false; becomes true once system owner has created an admin person who can sign in
    Boolean configured

    static constraints = {
        logo nullable: true
    }
}
