using log4net;
using Road.Base.Packets;
using System;
using System.Collections;
using System.Net.Sockets;
using System.Reflection;
using System.Text;
using System.Threading;

namespace Game.Base.Packets
{
    public class StreamProcessor
    {
        public static byte[] KEY = new byte[8] { 174, 191, 86, 120, 171, 205, 239, 241 }; //174,191,86,120,171,205,239,241

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected readonly BaseClient m_client;

        protected int m_firstPkgOffset;

        protected int m_sendBufferLength;

        protected bool m_sendingTcp;

        protected Queue m_tcpQueue;

        protected byte[] m_tcpSendBuffer;

        private FSM receive_fsm;

        private SocketAsyncEventArgs send_event;

        private FSM send_fsm;

        public StreamProcessor(BaseClient client)
        {
            m_client = client;
            m_client.resetKey();
            m_tcpSendBuffer = client.SendBuffer;
            m_tcpQueue = new Queue(256);
            send_event = new SocketAsyncEventArgs();
            send_event.UserToken = this;
            send_event.Completed += AsyncTcpSendCallback;
            send_event.SetBuffer(m_tcpSendBuffer, 0, 0);
            send_fsm = new FSM(2059198199, 1501, "send_fsm");
            receive_fsm = new FSM(2059198199, 1501, "receive_fsm");
        }

        private static void AsyncSendTcpImp(object state)
        {
            StreamProcessor sender = state as StreamProcessor;
            BaseClient client = sender.m_client;
            try
            {
                AsyncTcpSendCallback(sender, sender.send_event);
            }
            catch (Exception exception)
            {
                log.Error("AsyncSendTcpImp", exception);
                client.Disconnect();
            }
        }

        private static void AsyncTcpSendCallback(object sender, SocketAsyncEventArgs e)
        {
            StreamProcessor userToken = (StreamProcessor)e.UserToken;
            BaseClient client = userToken.m_client;
            try
            {
                Queue tcpQueue = userToken.m_tcpQueue;
                if (tcpQueue == null || !client.Socket.Connected)
                {
                    return;
                }
                int bytesTransferred = e.BytesTransferred;
                byte[] tcpSendBuffer = userToken.m_tcpSendBuffer;
                int length = 0;
                if (bytesTransferred != e.Count && userToken.m_sendBufferLength > bytesTransferred)
                {
                    length = userToken.m_sendBufferLength - bytesTransferred;
                    Array.Copy(tcpSendBuffer, bytesTransferred, tcpSendBuffer, 0, length);
                }
                e.SetBuffer(0, 0);
                int firstPkgOffset = userToken.m_firstPkgOffset;
                lock (tcpQueue.SyncRoot)
                {
                    int num4 = 0;
                    if (tcpQueue.Count > 0)
                    {
                        do
                        {
                            PacketIn @in = (PacketIn)tcpQueue.Peek();
                            int num5 = ((!client.Encryted) ? @in.CopyTo(tcpSendBuffer, length, firstPkgOffset) : @in.CopyTo3(tcpSendBuffer, length, firstPkgOffset, client.SEND_KEY, ref client.numPacketProcces));
                            num4 = ((num5 == 0) ? (num4 + 1) : 0);
                            firstPkgOffset += num5;
                            length += num5;
                            if (@in.Length <= firstPkgOffset)
                            {
                                tcpQueue.Dequeue();
                                firstPkgOffset = 0;
                                if (client.Encryted)
                                {
                                    userToken.send_fsm.UpdateState();
                                    @in.isSended = true;
                                }
                            }
                            if (tcpSendBuffer.Length == length)
                            {
                                break;
                            }
                            if (num4 > 5)
                            {
                                @in.isSended = true;
                                break;
                            }
                        }
                        while (tcpQueue.Count > 0);
                    }
                    userToken.m_firstPkgOffset = firstPkgOffset;
                    if (length <= 0)
                    {
                        userToken.m_sendingTcp = false;
                        return;
                    }
                }
                userToken.m_sendBufferLength = length;
                e.SetBuffer(0, length);
                if (!client.SendAsync(e))
                {
                    AsyncTcpSendCallback(sender, e);
                }
            }
            catch (Exception exception)
            {
                log.Error("AsyncTcpSendCallback", exception);
                log.WarnFormat("It seems <{0}> went linkdead. Closing connection. (SendTCP, {1}: {2})", client, exception.GetType(), exception.Message);
                client.Disconnect();
            }
        }

        public static byte[] cloneArrary(byte[] arr, int length = 8)
        {
            byte[] buffer = new byte[length];
            for (int i = 0; i < length; i++)
            {
                buffer[i] = arr[i];
            }
            return buffer;
        }

        public static byte[] decryptBytes(byte[] param1, int curOffset, int param2, byte[] param3)
        {
            byte[] buffer = new byte[param2];
            for (int i = 0; i < param2; i++)
            {
                buffer[i] = param1[i];
            }
            for (int j = 0; j < param2; j++)
            {
                if (j > 0)
                {
                    param3[j % 8] = (byte)((param3[j % 8] + param1[curOffset + j - 1]) ^ j);
                    buffer[j] = (byte)((param1[curOffset + j] - param1[curOffset + j - 1]) ^ param3[j % 8]);
                }
                else
                {
                    buffer[0] = (byte)(param1[curOffset] ^ param3[0]);
                }
            }
            return buffer;
        }

        public void Dispose()
        {
            send_event.Dispose();
            m_tcpQueue.Clear();
        }

        public static string PrintArray(byte[] arr, int length = 8)
        {
            StringBuilder builder = new StringBuilder();
            builder.Append("[");
            for (int i = 0; i < length; i++)
            {
                builder.AppendFormat("{0} ", arr[i]);
            }
            builder.Append("]");
            return builder.ToString();
        }

        public static string PrintArray(byte[] arr, int first, int length)
        {
            StringBuilder builder = new StringBuilder();
            builder.Append("[");
            for (int i = first; i < first + length; i++)
            {
                builder.AppendFormat("{0} ", arr[i]);
            }
            builder.Append("]");
            return builder.ToString();
        }

        public void ReceiveBytes(int numBytes)
        {
            lock (this)
            {
                byte[] packetBuf = m_client.PacketBuf;
                int num = m_client.PacketBufSize + numBytes;
                if (num < 20)
                {
                    m_client.PacketBufSize = num;
                    return;
                }
                m_client.PacketBufSize = 0;
                int curOffset = 0;
                do
                {
                    int num2 = 0;
                    if (m_client.Encryted)
                    {
                        _ = receive_fsm.count;
                        byte[] buffer2 = cloneArrary(m_client.RECEIVE_KEY);
                        for (; curOffset + 4 < num; curOffset++)
                        {
                            byte[] buffer3 = decryptBytes(packetBuf, curOffset, 8, buffer2);
                            if ((buffer3[0] << 8) + buffer3[1] == 29099)
                            {
                                num2 = (buffer3[2] << 8) + buffer3[3];
                                break;
                            }
                        }
                    }
                    else
                    {
                        for (; curOffset + 4 < num; curOffset++)
                        {
                            if ((packetBuf[curOffset] << 8) + packetBuf[curOffset + 1] == 29099)
                            {
                                num2 = (packetBuf[curOffset + 2] << 8) + packetBuf[curOffset + 3];
                                break;
                            }
                        }
                    }
                    if ((num2 == 0 || num2 >= 20) && num2 <= 8192)
                    {
                        int length = num - curOffset;
                        if (length >= num2 && num2 != 0)
                        {
                            GSPacketIn pkg = new GSPacketIn(new byte[8192], 8192);
                            if (m_client.Encryted)
                            {
                                pkg.CopyFrom3(packetBuf, curOffset, 0, num2, m_client.RECEIVE_KEY);
                            }
                            else
                            {
                                pkg.CopyFrom(packetBuf, curOffset, 0, num2);
                            }
                            pkg.ReadHeader();
                            try
                            {
                                m_client.OnRecvPacket(pkg);
                            }
                            catch (Exception exception)
                            {
                                if (log.IsErrorEnabled)
                                {
                                    log.Error("HandlePacket(pak)", exception);
                                }
                            }
                            curOffset += num2;
                            continue;
                        }
                        Array.Copy(packetBuf, curOffset, packetBuf, 0, length);
                        m_client.PacketBufSize = length;
                        break;
                    }
                    m_client.PacketBufSize = 0;
                    if (m_client.Strict)
                    {
                        m_client.Disconnect();
                    }
                    return;
                }
                while (num - 1 > curOffset);
                if (num - 1 == curOffset)
                {
                    packetBuf[0] = packetBuf[curOffset];
                    m_client.PacketBufSize = 1;
                }
            }
        }

        public void SendTCP(GSPacketIn packet)
        {
            if (packet != null)
            {
                packet.WriteHeader();
                packet.Offset = 0;
                if (!m_client.Socket.Connected)
                {
                    return;
                }
                try
                {
                    Statistics.BytesOut += packet.Length;
                    Statistics.PacketsOut++;
                    lock (m_tcpQueue.SyncRoot)
                    {
                        m_tcpQueue.Enqueue(packet);
                        if (m_sendingTcp)
                        {
                            return;
                        }
                        m_sendingTcp = true;
                    }
                    if (m_client.AsyncPostSend)
                    {
                        ThreadPool.QueueUserWorkItem(AsyncSendTcpImp, this);
                    }
                    else
                    {
                        AsyncTcpSendCallback(this, send_event);
                    }
                }
                catch (Exception exception)
                {
                    log.Error("SendTCP", exception);
                    log.WarnFormat("It seems <{0}> went linkdead. Closing connection. (SendTCP, {1}: {2})", m_client, exception.GetType(), exception.Message);
                    m_client.Disconnect();
                }
            }
        }

        public void SetFsm(int adder, int muliter)
        {
            send_fsm.Setup(adder, muliter);
            receive_fsm.Setup(adder, muliter);
        }
    }
}
