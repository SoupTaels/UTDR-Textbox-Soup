function CleanBatchBegin()
{
    if (is_array(global.__cleanBatch))
    {
        __CleanError("Cannot begin a batch when a batch has already been started");
        exit;
    }
    
    global.__cleanBatch = [];
}