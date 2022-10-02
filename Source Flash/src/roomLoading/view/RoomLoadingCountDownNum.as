package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingCountDownNum extends Sprite implements Disposeable
   {
       
      
      private var _numTxt:FilterFrameText;
      
      private var _num:int;
      
      public function RoomLoadingCountDownNum()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CountDownNumTxt");
         this._num = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM ? int(int(90)) : int(int(60));
         this._numTxt.text = this._num.toString() + " ";
         TweenMax.fromTo(this._numTxt,0.5,{
            "scaleX":0.5,
            "scaleY":0.5,
            "ease":Quint.easeIn,
            "alpha":0
         },{
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         addChild(this._numTxt);
      }
      
      public function updateNum() : void
      {
         --this._num;
         if(this._num < 0)
         {
            this._num = 0;
         }
         this._numTxt.text = this._num.toString();
      }
      
      public function dispose() : void
      {
         TweenMax.killTweensOf(this._numTxt);
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
