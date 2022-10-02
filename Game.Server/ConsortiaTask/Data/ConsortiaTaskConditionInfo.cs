namespace Game.Server.ConsortiaTask.Data
{
    public class ConsortiaTaskConditionInfo
    {
        public int ID
        {
            get;
            set;
        }
        public int TaskID
        {
            get;
            set;
        }
        /// <summary>
        /// 3,4,1,5,2
        /// </summary>
        public int Type
        {
            get;
            set;
        }
        public string Content
        {
            get;
            set;
        }
        public int Value
        {
            get;
            set;
        }
        public int Target
        {
            get;
            set;
        }
        public int Finish
        {
            get;
            set;
        }

        public int TemplateID
        {
            get;
            set;
        }
        public bool MustWin
        {
            get;
            set;
        }
        public int MissionID
        {
            get;
            set;
        }

        public bool Completed => Value >= Target;

        public void OnComplete(Game.Server.ConsortiaTask.Consortia consortia, ConsortiaTaskConditionInfo condition)
        {
            Complete?.Invoke(consortia, condition);
        }
        public event OnCompleted Complete;
        public delegate void OnCompleted(Game.Server.ConsortiaTask.Consortia consortia, ConsortiaTaskConditionInfo condition);
    }
}
