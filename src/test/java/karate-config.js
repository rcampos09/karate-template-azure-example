function fn() {
    var env = karate.env;
    //karate.log('karate.env system property was:', env);
    
    // Configuración base para todos los ambientes
    var config = {
        // ReqRes.in como API base
        apiUrl: 'https://reqres.in/api',
        
        // Datos de prueba comunes
        testData: {
            validUser: {
                email: "eve.holt@reqres.in",
                password: "cityslicka"
            },
            invalidUser: {
                email: "invalid@reqres.in",
                password: "wrongpass"
            },
            newUser: {
                name: "morpheus",
                job: "leader"
            }
        }
    };
    
    // Configuraciones específicas por ambiente
    if (env == 'qa') {
        karate.log('*** Running in QA Environment ***');
        config.apiUrl = 'https://reqres.in/api';
        config.testData.timeoutMs = 50000;
    } else if (env == 'dev') {
        karate.log('*** Running in DEV Environment ***');
        config.apiUrl = 'https://reqres.in/api';
        config.testData.timeoutMs = 10000;
    } else if (env == 'prod') {
        karate.log('*** Running in PROD Environment ***');
        config.apiUrl = 'https://reqres.in/api';
        config.testData.timeoutMs = 3000;
    } else {
        // Default to QA if no environment is specified
        karate.log('*** No environment specified, defaulting to QA ***');
        env = 'qa';
        config.apiUrl = 'https://reqres.in/api';
        config.testData.timeoutMs = 50000;
    }
    
    // Configuración de timeouts por defecto
    karate.configure('connectTimeout', config.testData.timeoutMs);
    karate.configure('readTimeout', config.testData.timeoutMs);
    
    // Configuración para logging detallado
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);
    karate.configure('printEnabled', true);
    
    // Log de configuración final
    karate.log('*** Configuration Summary ***');
    karate.log('Environment:', env);
    karate.log('API URL:', config.apiUrl);
    karate.log('Timeout:', config.testData.timeoutMs);
    
    return config;
}