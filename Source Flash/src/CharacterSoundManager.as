package
{
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class CharacterSoundManager
   {
      
      private static const MusicFailedTryTime:int = 3;
      
      private static var _instance:CharacterSoundManager;
      
      public static var SITE_MAIN:String = "";
       
      
      private var currentMusicTry:int = 0;
      
      private var _dic:Dictionary;
      
      private var _music:Array;
      
      private var _allowSound:Boolean;
      
      private var _currentSound:Dictionary;
      
      private var _allowMusic:Boolean;
      
      private var _currentMusic:String;
      
      private var _musicLoop:Boolean;
      
      private var _isMusicPlaying:Boolean;
      
      private var _musicPlayList:Array;
      
      private var _musicVolume:Number = 100;
      
      private var soundVolumn:Number = 100;
      
      private var _nc:NetConnection;
      
      private var _ns:NetStream;
      
      public function CharacterSoundManager()
      {
         super();
         this._dic = new Dictionary();
         this._currentSound = new Dictionary(true);
         this._isMusicPlaying = false;
         this._musicLoop = false;
         this._allowMusic = true;
         this._allowSound = true;
         this._nc = new NetConnection();
         this._nc.connect(null);
         this._ns = new NetStream(this._nc);
         this._ns.bufferTime = 0.3;
         this._ns.client = this;
         this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.__netStatus);
         this._musicPlayList = [];
      }
      
      public static function get instance() : CharacterSoundManager
      {
         if(_instance == null)
         {
            _instance = new CharacterSoundManager();
         }
         return _instance;
      }
      
      public function get allowSound() : Boolean
      {
         return this._allowSound;
      }
      
      public function set allowSound(value:Boolean) : void
      {
         if(this._allowSound == value)
         {
            return;
         }
         this._allowSound = value;
         if(!this._allowSound)
         {
            this.stopAllSound();
         }
      }
      
      public function addSound(id:String, key:Class) : void
      {
         this._dic[id] = key;
      }
      
      public function get allowMusic() : Boolean
      {
         return this._allowMusic;
      }
      
      public function set allowMusic(value:Boolean) : void
      {
         if(this._allowMusic == value)
         {
            return;
         }
         this._allowMusic = value;
         if(this._allowMusic)
         {
            this.resumeMusic();
         }
         else
         {
            this.pauseMusic();
         }
      }
      
      public function onPlayStatus(e:*) : void
      {
         trace("-------------------------------");
         trace("------------Fuck---------------");
         trace("-------------------------------");
      }
      
      public function setup(music:Array, siteMain:String) : void
      {
         this._music = !!Boolean(music) ? music : [];
         SITE_MAIN = siteMain;
      }
      
      public function setConfig(allowMusic:Boolean, allowSound:Boolean, musicVolumn:Number, soundVolumn:Number) : void
      {
         this.allowMusic = allowMusic;
         this.allowSound = allowSound;
         this._musicVolume = musicVolumn;
         if(this.allowMusic)
         {
            this._ns.soundTransform = new SoundTransform(musicVolumn / 100);
         }
         this.soundVolumn = soundVolumn;
      }
      
      public function setupAudioResource() : void
      {
         this.init();
      }
      
      private function init() : void
      {
      }
      
      public function checkHasSound(sound:String) : Boolean
      {
         if(this._dic[sound] != null)
         {
            return true;
         }
         return false;
      }
      
      public function play(id:String, allowMulti:Boolean = false, replaceSame:Boolean = true, loop:Number = 0) : void
      {
         var cls:Class = null;
         if(this._dic[id] == null)
         {
            try
            {
               cls = getDefinitionByName(id) as Class;
               this._dic[id] = cls;
            }
            catch(e:Error)
            {
               trace("sound not found: " + id);
               return;
            }
         }
         if(this._allowSound)
         {
            try
            {
               if(allowMulti || replaceSame || !this.isPlaying(id))
               {
                  this.playSoundImp(id,loop);
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function playButtonSound() : void
      {
         this.play("008");
      }
      
      private function playSoundImp(id:String, loop:Number) : void
      {
         var ss:Sound = new this._dic[id]();
         var sc:SoundChannel = ss.play(0,loop,new SoundTransform(this.soundVolumn / 100));
         sc.addEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
         this._currentSound[id] = sc;
      }
      
      private function __soundComplete(evt:Event) : void
      {
         var i:* = null;
         var c:SoundChannel = evt.currentTarget as SoundChannel;
         c.removeEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
         c.stop();
         for(i in this._currentSound)
         {
            if(this._currentSound[i] == c)
            {
               this._currentSound[i] = null;
               return;
            }
         }
      }
      
      public function stop(s:String) : void
      {
         if(this._currentSound[s])
         {
            this._currentSound[s].stop();
            this._currentSound[s] = null;
         }
      }
      
      public function stopAllSound() : void
      {
         var sound:SoundChannel = null;
         for each(sound in this._currentSound)
         {
            if(sound)
            {
               sound.stop();
            }
         }
         this._currentSound = new Dictionary();
      }
      
      public function isPlaying(s:String) : Boolean
      {
         return this._currentSound[s] == null ? Boolean(Boolean(false)) : Boolean(Boolean(true));
      }
      
      public function playMusic(id:String, loops:Boolean = true, replaceSame:Boolean = false) : void
      {
         this.currentMusicTry = 0;
         if(replaceSame || this._currentMusic != id)
         {
            if(this._isMusicPlaying)
            {
               this.stopMusic();
            }
            this.playMusicImp([id],loops);
         }
      }
      
      private function playMusicImp(list:Array, loops:Boolean) : void
      {
         this._musicLoop = loops;
         this._musicPlayList = list;
         if(list.length > 0)
         {
            this._currentMusic = list[0];
            this._isMusicPlaying = true;
            this._ns.play(SITE_MAIN + "sound/" + this._currentMusic + ".flv");
            this._ns.soundTransform = new SoundTransform(this._musicVolume / 100);
            if(!this._allowMusic)
            {
               this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
               this.pauseMusic();
            }
            else
            {
               this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
            }
         }
      }
      
      private function __onMusicStaus(e:NetStatusEvent) : void
      {
         if(e.info.code == "NetConnection.Connect.Failed" || e.info.code == "NetStream.Play.StreamNotFound")
         {
            if(this.currentMusicTry < MusicFailedTryTime)
            {
               ++this.currentMusicTry;
               this._ns.play(SITE_MAIN + "sound/" + this._currentMusic + ".flv");
            }
            else
            {
               this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
            }
         }
         else if(e.info.code == "NetStream.Play.Start")
         {
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.__onMusicStaus);
         }
      }
      
      public function setMusicVolumeByRatio(ratio:Number) : void
      {
         if(this.allowMusic)
         {
            this._musicVolume *= ratio;
            this._ns.soundTransform = new SoundTransform(this._musicVolume / 100);
         }
      }
      
      public function pauseMusic() : void
      {
         if(this._isMusicPlaying)
         {
            this._ns.soundTransform = new SoundTransform(0);
            this._isMusicPlaying = false;
         }
      }
      
      public function resumeMusic() : void
      {
         if(this._allowMusic && this._currentMusic)
         {
            this._ns.soundTransform = new SoundTransform(this._musicVolume / 100);
            this._isMusicPlaying = true;
         }
      }
      
      public function stopMusic() : void
      {
         if(this._currentMusic)
         {
            this._isMusicPlaying = false;
            this._ns.close();
            this._currentMusic = null;
         }
      }
      
      public function playGameBackMusic(id:String) : void
      {
         this.playMusicImp([id,id],false);
      }
      
      private function __netStatus(event:NetStatusEvent) : void
      {
         var index:int = 0;
         if(event.info.code == "NetStream.Play.Stop")
         {
            if(this._musicLoop)
            {
               this.playMusicImp(this._musicPlayList,true);
            }
            else if(this._musicPlayList.length > 0)
            {
               this.playMusicImp(this._musicPlayList,false);
            }
            else
            {
               index = 0;
               this.playMusicImp([this._music[index]],false);
            }
         }
      }
      
      public function onMetaData(info:Object) : void
      {
      }
      
      public function onXMPData(info:Object) : void
      {
      }
      
      public function onCuePoint(info:Object) : void
      {
      }
   }
}
