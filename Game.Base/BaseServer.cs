using log4net;
using System;
using System.Collections.Specialized;
using System.Net;
using System.Net.Sockets;
using System.Reflection;

namespace Game.Base
{
    public class BaseServer
    {
        protected readonly HybridDictionary _clients = new HybridDictionary();

        protected Socket _linstener;

        protected SocketAsyncEventArgs ac_event = new SocketAsyncEventArgs();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static readonly int SEND_BUFF_SIZE = 16384;

        public int ClientCount=> _clients.Count;

        public BaseServer()
        {
			ac_event.Completed += AcceptAsyncCompleted;
        }

        private void AcceptAsync()
        {
			try
			{
				if (_linstener != null)
				{
					SocketAsyncEventArgs e = new SocketAsyncEventArgs();
					e.Completed += AcceptAsyncCompleted;
					_linstener.AcceptAsync(e);
				}
			}
			catch (Exception exception)
			{
				log.Error("AcceptAsync is error!", exception);
			}
        }

        private void AcceptAsyncCompleted(object sender, SocketAsyncEventArgs e)
        {
			Socket connectedSocket = null;
			try
			{
				connectedSocket = e.AcceptSocket;
				connectedSocket.SendBufferSize = SEND_BUFF_SIZE;
				BaseClient newClient = GetNewClient();
				try
				{
					if (log.IsInfoEnabled)
					{
						log.Info("Incoming connection from " + (connectedSocket.Connected ? connectedSocket.RemoteEndPoint.ToString() : "socket disconnected"));
					}
					lock (_clients.SyncRoot)
					{
						_clients.Add(newClient, newClient);
						newClient.Disconnected += client_Disconnected;
					}
					newClient.Connect(connectedSocket);
					newClient.ReceiveAsync();
				}
				catch (Exception exception)
				{
					log.ErrorFormat("create client failed:{0}", exception);
					newClient.Disconnect();
				}
			}
			catch
			{
				if (connectedSocket != null)
				{
					try
					{
						connectedSocket.Close();
					}
					catch
					{
					}
				}
			}
			finally
			{
				e.Dispose();
				AcceptAsync();
			}
        }

        private void client_Disconnected(BaseClient client)
        {
			client.Disconnected -= client_Disconnected;
			RemoveClient(client);
        }

        public void Dispose()
        {
			ac_event.Dispose();
        }

        public BaseClient[] GetAllClients()
        {
			lock (_clients.SyncRoot)
			{
				BaseClient[] array = new BaseClient[_clients.Count];
				_clients.Keys.CopyTo(array, 0);
				return array;
			}
        }

        protected virtual BaseClient GetNewClient()
        {
			return new BaseClient(new byte[8192], new byte[8192]);
        }

        public virtual bool InitSocket(IPAddress ip, int port)
        {
			try
			{
				_linstener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
				_linstener.Bind(new IPEndPoint(ip, port));
			}
			catch (Exception exception)
			{
				log.Error("InitSocket", exception);
				return false;
			}
			return true;
        }

        public virtual void RemoveClient(BaseClient client)
        {
			lock (_clients.SyncRoot)
			{
				_clients.Remove(client);
			}
        }

        public virtual bool Start()
        {
			if (_linstener == null)
			{
				return false;
			}
			try
			{
				_linstener.Listen(100);
				AcceptAsync();
				if (log.IsDebugEnabled)
				{
					log.Debug("Server is now listening to incoming connections!");
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Start", exception);
				}
				if (_linstener != null)
				{
					_linstener.Close();
				}
				return false;
			}
			return true;
        }

        public virtual void Stop()
        {
			log.Debug("Stopping server! - Entering method");
			try
			{
				if (_linstener != null)
				{
					Socket linstener = _linstener;
					_linstener = null;
					linstener.Close();
					log.Debug("Server is no longer listening for incoming connections!");
				}
			}
			catch (Exception exception)
			{
				log.Error("Stop", exception);
			}
			if (_clients != null)
			{
				lock (_clients.SyncRoot)
				{
					try
					{
						BaseClient[] array = new BaseClient[_clients.Keys.Count];
						_clients.Keys.CopyTo(array, 0);
						BaseClient[] array2 = array;
						for (int i = 0; i < array2.Length; i++)
						{
							array2[i].Disconnect();
						}
						log.Debug("Stopping server! - Cleaning up client list!");
					}
					catch (Exception exception2)
					{
						log.Error("Stop", exception2);
					}
				}
			}
			log.Debug("Stopping server! - End of method!");
        }
    }
}
