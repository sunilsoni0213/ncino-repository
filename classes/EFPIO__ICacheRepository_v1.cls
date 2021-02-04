/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ICacheRepository_v1 {
    void SetDataEncryptionFlag(Boolean param0);
    void SetDataEncryptionProvider(Object param0);
    void SetLoggingProvider(EFPIO.ILoggingProvider_v1 param0);
    void SetPartitionName(String param0);
    void SetTTL(Integer param0);
    Object get(String param0, System.Type param1);
    void put(String param0, Object param1);
    Object remove(String param0);
}
