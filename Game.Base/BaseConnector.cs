using log4net;
using System.Net;
using System.Net.Sockets;
using System.Reflection;
using System.Threading;

namespace Game.Base
{
    public class BaseConnector : BaseClient
    {
        private bool _autoReconnect;

        private IPEndPoint _remoteEP;

        private SocketAsyncEventArgs e;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static readonly int RECONNECT_INTERVAL = 10000;

        private Timer timer;

        public IPEndPoint RemoteEP=> _remoteEP;

        public BaseConnector(string ip, int port, bool autoReconnect, byte[] readBuffer, byte[] sendBuffer)
			: base(readBuffer, sendBuffer)
        {
			_remoteEP = new IPEndPoint(IPAddress.Parse(ip), port);
			_autoReconnect = autoReconnect;
			e = new SocketAsyncEventArgs();
        }

        public bool Connect()
        {
			try
			{
				m_sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
				m_readBufEnd = 0;
				m_sock.Connect(_remoteEP);
				log.InfoFormat("Connected to {0}", _remoteEP);
			}
			catch
			{
				log.ErrorFormat("Connect {0} failed!", _remoteEP);
				m_sock = null;
				return false;
			}
			OnConnect();
			ReceiveAsync();
			return true;
        }

        private static void RetryTimerCallBack(object target)
        {
			BaseConnector connector = target as BaseConnector;
			if (connector != null)
			{
				connector.TryReconnect();
			}
			else
			{
				log.Error("BaseConnector retryconnect timer return NULL!");
			}
        }

        private void TryReconnect()
        {
			if (Connect())
			{
				if (timer != null)
				{
					timer.Dispose();
					timer = null;
				}
				ReceiveAsync();
				return;
			}
			log.ErrorFormat("Reconnect {0} failed:", _remoteEP);
			log.ErrorFormat("Retry after {0} ms!", RECONNECT_INTERVAL);
			if (timer == null)
			{
				timer = new Timer(RetryTimerCallBack, this, -1, -1);
			}
			timer.Change(RECONNECT_INTERVAL, -1);
        }
    }
}
