using Game.Base;
using Game.Base.Packets;
using Game.Server.Managers;
using log4net;
using System;
using System.Reflection;
using System.Text;
using System.Threading;

namespace Game.Server
{
    public class GameClient : BaseClient
    {
        protected GameServer _srvr;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public int Lottery;

        protected IPacketLib m_packetLib;

        protected PacketProcessor m_packetProcessor;

        protected long m_pingTime;

        protected GamePlayer m_player;

        private static readonly byte[] POLICY = Encoding.UTF8.GetBytes("<?xml version=\"1.0\"?><!DOCTYPE cross-domain-policy SYSTEM \"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\"><cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>\0");

        public string tempData;

        public int Version;

        private string m_hwid;

        public IPacketLib Out
        {
			get
			{
				return m_packetLib;
			}
			set
			{
				m_packetLib = value;
			}
        }

        public PacketProcessor PacketProcessor=> m_packetProcessor;

        public long PingTime=> m_pingTime;

        public string HWID
        {
			get
			{
				return m_hwid;
			}
			set
			{
				m_hwid = value;
			}
        }

        public GamePlayer Player
        {
			get
			{
				return m_player;
			}
			set
			{
				Interlocked.Exchange(ref m_player, value)?.Quit();
			}
        }

        public GameServer Server=> _srvr;

        public GameClient(GameServer svr, byte[] read, byte[] send)
			: base(read, send)
        {
			m_pingTime = DateTime.Now.Ticks;
			Lottery = -1;
			tempData = string.Empty;
			m_pingTime = DateTime.Now.Ticks;
			_srvr = svr;
			m_player = null;
			base.Encryted = true;
			base.AsyncPostSend = true;
        }

        public override void Disconnect()
        {
			base.Disconnect();
        }

        public override void DisplayMessage(string msg)
        {
			base.DisplayMessage(msg);
        }

        protected override void OnConnect()
        {
			base.OnConnect();
			m_pingTime = DateTime.Now.Ticks;
        }

        protected override void OnDisconnect()
        {
			try
			{
				GamePlayer gamePlayer = Interlocked.Exchange(ref m_player, null);
				if (gamePlayer != null)
				{
					gamePlayer.FightBag.ClearBag();
					LoginMgr.ClearLoginPlayer(gamePlayer.PlayerCharacter.ID, this);
					gamePlayer.Quit();
				}
				byte[] sendBuffer = m_sendBuffer;
				m_sendBuffer = null;
				_srvr.ReleasePacketBuffer(sendBuffer);
				sendBuffer = m_readBuffer;
				m_readBuffer = null;
				_srvr.ReleasePacketBuffer(sendBuffer);
				base.OnDisconnect();
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("OnDisconnect", exception);
				}
			}
        }

        public override void OnRecv(int num_bytes)
        {
			if (m_packetProcessor != null)
			{
				base.OnRecv(num_bytes);
			}
			else if (m_readBuffer[0] == 60)
			{
				m_sock.Send(POLICY);
			}
			else
			{
				base.OnRecv(num_bytes);
			}
			m_pingTime = DateTime.Now.Ticks;
        }

        public override void OnRecvPacket(GSPacketIn pkg)
        {
			if (m_packetProcessor == null)
			{
				m_packetLib = AbstractPacketLib.CreatePacketLibForVersion(1, this);
				m_packetProcessor = new PacketProcessor(this);
			}
			if (m_player != null)
			{
				pkg.ClientID = m_player.PlayerId;
				pkg.WriteHeader();
			}
			m_packetProcessor.HandlePacket(pkg);
        }

        public override void SendTCP(GSPacketIn pkg)
        {
			base.SendTCP(pkg);
        }

        public override string ToString()
        {
			return new StringBuilder(128).Append(" pakLib:").Append((Out == null) ? "(null)" : Out.GetType().FullName).Append(" IP:")
				.Append(base.TcpEndpoint)
				.Append(" char:")
				.Append((Player == null) ? "null" : Player.PlayerCharacter.NickName)
				.ToString();
        }
    }
}
