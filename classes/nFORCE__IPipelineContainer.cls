/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IPipelineContainer {
    Boolean executePipeline(nFORCE.IPipelineContext param0);
    nFORCE.IPipelineContext getCurrentContext();
    List<nFORCE.IPipelineComponent> getPipeline();
    void postProcessComponent(nFORCE.IPipelineContext param0, nFORCE.IPipelineComponent param1);
    void postProcessPipeline(nFORCE.IPipelineContext param0);
    void preProcessComponent(nFORCE.IPipelineContext param0, nFORCE.IPipelineComponent param1);
    void preProcessPipeline(nFORCE.IPipelineContext param0);
}
