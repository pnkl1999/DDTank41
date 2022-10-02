namespace Center.Server
{
    public class Player
    {
        public ServerClient CurrentServer;

        public int Id;

        public bool IsFirst;

        public long LastTime;

        public string Name;

        public string NickName;

        public string Password;

        public ePlayerState State;
    }
}
