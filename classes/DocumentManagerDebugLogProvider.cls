global class DocumentManagerDebugLogProvider extends nFORCE.DebugLogProvider implements nFORCE.ILogProvider {
    public void log(LoggingLevel level, Type classType, Object message){
        System.debug(level, classType + ':: ' + message);
    }
}