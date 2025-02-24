package examples.users;

import com.intuit.karate.junit5.Karate;

class UsersRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("TC12345_ValidarLogin")
                     .outputCucumberJson(true)  // Asegura que genera JSON
                     .reportDir("target/cucumber-reports") // Define el directorio de reportes
                     .karateEnv("qa")
                     .relativeTo(getClass());
    }
    
}
