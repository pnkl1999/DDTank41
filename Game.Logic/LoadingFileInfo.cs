namespace Game.Logic
{
    public class LoadingFileInfo
    {
        public string ClassName;

        public string Path;

        public int Type;

        public LoadingFileInfo(int type, string path, string className)
        {
			Type = type;
			Path = path;
			ClassName = className;
        }
    }
}
