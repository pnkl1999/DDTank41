using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Server.GameUtils
{
    public class Scene
    {
        protected ReaderWriterLock _locker = new ReaderWriterLock();

        protected Dictionary<int, GamePlayer> _players = new Dictionary<int, GamePlayer>();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public Scene(ServerInfo info)
        {
        }

        public bool AddPlayer(GamePlayer player)
        {
			_locker.AcquireWriterLock(-1);
			try
			{
				if (_players.ContainsKey(player.PlayerCharacter.ID))
				{
					_players[player.PlayerCharacter.ID] = player;
					return true;
				}
				_players.Add(player.PlayerCharacter.ID, player);
				return true;
			}
			finally
			{
				_locker.ReleaseWriterLock();
			}
        }

        public GamePlayer[] GetAllPlayer()
        {
			GamePlayer[] array = null;
			_locker.AcquireReaderLock(10000);
			try
			{
				array = _players.Values.ToArray();
			}
			finally
			{
				_locker.ReleaseReaderLock();
			}
			if (array != null)
			{
				return array;
			}
			return new GamePlayer[0];
        }

        public GamePlayer GetClientFromID(int id)
        {
			if (_players.Keys.Contains(id))
			{
				return _players[id];
			}
			return null;
        }

        public void RemovePlayer(GamePlayer player)
        {
			_locker.AcquireWriterLock(-1);
			try
			{
				if (_players.ContainsKey(player.PlayerCharacter.ID))
				{
					_players.Remove(player.PlayerCharacter.ID);
				}
			}
			finally
			{
				_locker.ReleaseWriterLock();
			}
			GamePlayer[] allPlayer = GetAllPlayer();
			GSPacketIn gSPacketIn = null;
			GamePlayer[] array = allPlayer;
			GamePlayer[] array2 = array;
			foreach (GamePlayer gamePlayer in array2)
			{
				if (gSPacketIn == null)
				{
					gSPacketIn = gamePlayer.Out.SendSceneRemovePlayer(player);
				}
				else
				{
					gamePlayer.Out.SendTCP(gSPacketIn);
				}
			}
        }

        public void SendToALL(GSPacketIn pkg)
        {
			SendToALL(pkg, null);
        }

        public void SendToALL(GSPacketIn pkg, GamePlayer except)
        {
			GamePlayer[] allPlayer = GetAllPlayer();
			GamePlayer[] array = allPlayer;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != except)
				{
					gamePlayer.Out.SendTCP(pkg);
				}
			}
        }
    }
}
