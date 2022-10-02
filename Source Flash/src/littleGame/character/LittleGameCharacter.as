package littleGame.character
{
   import character.ComplexBitmapCharacter;
   import character.action.ComplexBitmapAction;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class LittleGameCharacter extends ComplexBitmapCharacter implements Disposeable
   {
      
      public static const WIDTH:Number = 230;
      
      public static const HEIGHT:Number = 175;
      
      public static var DEFINE:XML;
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _headBmd:BitmapData;
      
      private var _bodyBmd:BitmapData;
      
      private var headBmds:Vector.<BitmapData>;
      
      private var _loader:LittleGameCharaterLoader;
      
      private var hasFaceColor:Boolean = false;
      
      private var hasClothColor:Boolean = false;
      
      private var _isComplete:Boolean;
      
      private var _currentAct:String;
      
      private var _currentSoundPlayed:Boolean;
      
      public function LittleGameCharacter(playerInfo:PlayerInfo, littleGameId:int = 1)
      {
         this._playerInfo = playerInfo;
         var recordColor:Array = this._playerInfo.Colors.split(",");
         this.hasFaceColor = Boolean(recordColor[5]);
         this.hasClothColor = Boolean(recordColor[4]);
         this._loader = new LittleGameCharaterLoader(this._playerInfo,littleGameId);
         this._loader.load(this.onComplete);
         super(null,null,"",WIDTH,HEIGHT);
      }
      
      public static function setup() : void
      {
         var loader:URLLoader = null;
         var onXmlComplete:Function = null;
         loader = null;
         onXmlComplete = null;
         onXmlComplete = function(event:Event):void
         {
            event.currentTarget.removeEventListener(Event.COMPLETE,onXmlComplete);
            DEFINE = XML(loader.data);
         };
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,onXmlComplete);
         loader.load(new URLRequest(PathManager.SITE_MAIN + "flash/characterDefine.xml?rnd=" + Math.random()));
      }
      
      override public function doAction(action:String) : void
      {
         var item:FrameByFrameItem = null;
         play();
         var a:ComplexBitmapAction = _actionSet.getAction(action) as ComplexBitmapAction;
         if(a)
         {
            if(_currentAction == null)
            {
               this.currentAction = a;
            }
            else if(a.priority >= _currentAction.priority)
            {
               for each(item in _currentAction.assets)
               {
                  item.stop();
                  removeItem(item);
               }
               _currentAction.reset();
               this.currentAction = a;
               if(action.indexOf("back") != -1)
               {
                  _items.reverse();
               }
            }
         }
         this._currentAct = action;
      }
      
      override protected function set currentAction(action:ComplexBitmapAction) : void
      {
         var item1:FrameByFrameItem = null;
         _currentAction = action;
         _autoStop = _currentAction.endStop;
         for each(item1 in _currentAction.assets)
         {
            item1.play();
            addItem(item1);
         }
         if(!StringUtils.isEmpty(_currentAction.sound) && _soundEnabled && (this._currentAct != action.name || !this._currentSoundPlayed))
         {
            SoundManager.instance.play(_currentAction.sound);
            this._currentSoundPlayed = true;
         }
      }
      
      override protected function update() : void
      {
         super.update();
      }
      
      private function onComplete() : void
      {
         this._headBmd = this._loader.getContent()[0];
         this._bodyBmd = this._loader.getContent()[1];
         var bmds:Dictionary = new Dictionary();
         bmds["head"] = this._headBmd;
         bmds["body"] = this._bodyBmd;
         bmds["effect"] = this._loader.getContent()[2];
         bmds["specialHead"] = this._loader.getContent()[4];
         assets = bmds;
         this.headBmds = new Vector.<BitmapData>();
         this.headBmds.push(this._loader.getContent()[3],this._loader.getContent()[4],this._loader.getContent()[5]);
         super.description = DEFINE;
         dispatchEvent(new Event(Event.COMPLETE));
         if(this._currentAct != null)
         {
            this.doAction(this._currentAct);
         }
      }
      
      override public function get actions() : Array
      {
         return _actionSet.actions;
      }
      
      private function updateRenderSource(resource:String, renderData:BitmapData) : void
      {
         var item:FrameByFrameItem = null;
         for each(item in _bitmapRendItems)
         {
            if(item.sourceName == resource)
            {
               item.source = renderData;
               if(item is CrossFrameItem)
               {
                  CrossFrameItem(item).frames = CrossFrameItem(item).frames;
               }
            }
         }
      }
      
      public function setFunnyHead(type:uint = 0) : void
      {
         if(this.headBmds == null || type > this.headBmds.length - 1)
         {
            return;
         }
         this.updateRenderSource("specialHead",this.headBmds[type]);
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         if(assets)
         {
            assets["head"] = null;
            assets["body"] = null;
            assets["effect"] = null;
            assets["specialHead"] = null;
            assets = null;
         }
         super.dispose();
         if(this._headBmd)
         {
            this._headBmd.dispose();
            this._headBmd = null;
         }
         if(this._bodyBmd && this.hasClothColor)
         {
            this._bodyBmd.dispose();
         }
         this._bodyBmd = null;
         if(this._loader)
         {
            this._loader.dispose();
         }
         if(this.hasFaceColor && this.headBmds)
         {
            for(i = 0; i < this.headBmds.length; i++)
            {
               if(this.headBmds[i])
               {
                  this.headBmds[i].dispose();
               }
            }
         }
         this.headBmds = null;
      }
   }
}
