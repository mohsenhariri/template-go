package initializers

import (
	"os"
)

// var DSN string
// var Secret string
var Port string

func CheckEnv() {

	// DSN = readEnv("DB")
	// Secret = readEnv("SECRET")
	Port = readEnv("PORT")

}

func readEnv(envName string) string {

	if val, ok := os.LookupEnv(envName); !ok {
		// log.Fatal("err loading environment variables")
		panic("error loading environment variables")

	} else {
		return val
	}
}
