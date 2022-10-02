package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   import labyrinth.LabyrinthManager;
   
   public class TransmissionGate extends SimpleObject implements Disposeable, ITipedDisplay
   {
       
      
      private var _lightColor:ColorTransform;
      
      private var _normalColor:ColorTransform;
      
      protected var _tipData:Object;
      
      protected var _tipDirction:String;
      
      protected var _tipGapV:int;
      
      protected var _tipGapH:int;
      
      protected var _tipStyle:String;
      
      private var _timer:Timer;
      
      public function TransmissionGate(param1:int, param2:int, param3:String, param4:String)
      {
         super(param1,param2,param3,param4);
         _canCollided = true;
         setCollideRect(-50,-100,50,100);
         getCollideRect();
         this._lightColor = new ColorTransform();
         this._lightColor.redOffset = 0;
         this._lightColor.greenOffset = 145;
         this._lightColor.blueOffset = 239;
         this._normalColor = new ColorTransform();
         mouseChildren = true;
         mouseEnabled = true;
         buttonMode = false;
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "4";
         this.tipGapV = 90;
         this.tipGapH = -20;
         if(LabyrinthManager.Instance.model.currentFloor == 30)
         {
            this.tipData = LanguageMgr.GetTranslation("game.objects.TransmissionGate.tips");
         }
         else
         {
            this.tipData = LanguageMgr.GetTranslation("game.objects.TransmissionGate.tipsII");
         }
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function __timerComplete(param1:TimerEvent) : void
      {
         GameInSocketOut.sendGameSkipNext(0);
      }
      
      override protected function creatMovie(param1:String) : void
      {
         var _loc2_:Class = ModuleLoader.getDefinition(m_model) as Class;
         if(_loc2_)
         {
            m_movie = new _loc2_();
            m_movie.scaleY = 1.7;
            m_movie.scaleX = 1.7;
            m_movie.addEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
            m_movie.addEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
            m_movie.addEventListener(MouseEvent.CLICK,this.__onClick);
            addChild(m_movie);
         }
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
      }
      
      protected function __onOut(param1:MouseEvent) : void
      {
         if(m_movie && m_movie.transform)
         {
            m_movie.transform.colorTransform = this._normalColor;
         }
      }
      
      protected function __onOver(param1:MouseEvent) : void
      {
         if(m_movie && m_movie.transform)
         {
            m_movie.transform.colorTransform = this._lightColor;
         }
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(m_movie)
         {
            m_movie.removeEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
            m_movie.removeEventListener(MouseEvent.MOUSE_OVER,this.__onOut);
         }
         super.dispose();
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(this._tipData == param1)
         {
            return;
         }
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirction;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         if(this._tipDirction == param1)
         {
            return;
         }
         this._tipDirction = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         if(this._tipGapV == param1)
         {
            return;
         }
         this._tipGapV = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         if(this._tipGapH == param1)
         {
            return;
         }
         this._tipGapH = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         if(this._tipStyle == param1)
         {
            return;
         }
         this._tipStyle = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
