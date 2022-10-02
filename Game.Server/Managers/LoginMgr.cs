using Bussiness;
using System.Collections.Generic;

namespace Game.Server.Managers
{
    public class LoginMgr
    {
        private static object _locker = new object();

        private static Dictionary<int, GameClient> _players = new Dictionary<int, GameClient>();

        public static void Add(int player, GameClient server)
        {
			GameClient gameClient = null;
			lock (_locker)
			{
				if (_players.ContainsKey(player))
				{
					GameClient gameClient2 = _players[player];
					if (gameClient2 != null)
					{
						gameClient = gameClient2;
					}
					_players[player] = server;
				}
				else
				{
					_players.Add(player, server);
				}
			}
			if (gameClient != null)
			{
				gameClient.Out.SendKitoff(LanguageMgr.GetTranslation("Game.Server.LoginNext"));
				gameClient.Disconnect();
			}
        }

        public static void ClearLoginPlayer(int playerId)
        {
			GameClient gameClient = null;
			lock (_locker)
			{
				if (_players.ContainsKey(playerId))
				{
					gameClient = _players[playerId];
					_players.Remove(playerId);
				}
			}
			if (gameClient != null)
			{
				gameClient.Out.SendKitoff(LanguageMgr.GetTranslation("Game.Server.LoginNext"));
				gameClient.Disconnect();
			}
        }

        public static void ClearLoginPlayer(int playerId, GameClient client)
        {
			lock (_locker)
			{
				if (_players.ContainsKey(playerId) && _players[playerId] == client)
				{
					_players.Remove(playerId);
				}
			}
        }

        public static bool ContainsUser(int playerId)
        {
			lock (_locker)
			{
				return _players.ContainsKey(playerId) && _players[playerId].IsConnected;
			}
        }

        public static bool ContainsUser(string account)
        {
			lock (_locker)
			{
				foreach (GameClient value in _players.Values)
				{
					if (value != null && value.Player != null && value.Player.Account == account)
					{
						return true;
					}
				}
				return false;
			}
        }

        public static GamePlayer LoginClient(int playerId)
        {
			GameClient gameClient = null;
			lock (_locker)
			{
				if (_players.ContainsKey(playerId))
				{
					gameClient = _players[playerId];
					_players.Remove(playerId);
				}
			}
			return gameClient?.Player;
        }

        public static void Remove(int player)
        {
			lock (_locker)
			{
				if (_players.ContainsKey(player))
				{
					_players.Remove(player);
				}
			}
        }
    }
}
