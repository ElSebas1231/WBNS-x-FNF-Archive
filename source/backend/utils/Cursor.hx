package backend.utils;

import backend.haxeui.CursorHelper;
import lime.app.Future;
import openfl.display.BitmapData;
import openfl.utils.Assets;

@:nullSafety
class Cursor
{
  /**
   * The current cursor mode.
   * Set this value to change the cursor graphic.
   */
  public static var cursorMode(default, set):Null<CursorMode> = null;

  /**
   * Show the cursor.
   */
  public static inline function show():Void
  {
    FlxG.mouse.visible = true;
    // Reset the cursor mode.
    Cursor.cursorMode = Default;
  }

  /**
   * Hide the cursor.
   */
  public static inline function hide():Void
  {
    FlxG.mouse.visible = false;
    // Reset the cursor mode.
    Cursor.cursorMode = null;
  }

  public static inline function toggle():Void
  {
    if (FlxG.mouse.visible)
    {
      hide();
    }
    else
    {
      show();
    }
  }

  public static final CURSOR_DEFAULT_PARAMS:CursorParams =
    {
      graphic: "assets/shared/images/ui/cursor/cursor-default.png",
      scale: 1.0,
      offsetX: 0,
      offsetY: 0,
    };
  static var assetCursorDefault:Null<BitmapData> = null;

  static var assetCursorCross:Null<BitmapData> = null;
  public static final CURSOR_CROSS_PARAMS:CursorParams =
    {
      graphic: "assets/shared/images/ui/cursor/cursor-cross.png",
      scale: 1.0,
      offsetX: 0,
      offsetY: 0,
    };

  public static final CURSOR_ERASER_PARAMS:CursorParams =
    {
      graphic: "assets/shared/images/ui/cursor/cursor-eraser.png",
      scale: 1.0,
      offsetX: 0,
      offsetY: 0,
    };
  static var assetCursorEraser:Null<BitmapData> = null;

  static var assetCursorGrabbing:Null<BitmapData> = null;
  public static final CURSOR_GRABBING_PARAMS:CursorParams =
    {
      graphic: "assets/shared/images/ui/cursor/cursor-grabbing.png",
      scale: 1.0,
      offsetX: 0,
      offsetY: 0,
    };
    
  static var assetCursorPointer:Null<BitmapData> = null;
  public static final CURSOR_POINTER_PARAMS:CursorParams =
    {
      graphic: "assets/shared/images/ui/cursor/cursor-pointer.png",
      scale: 1.0,
      offsetX: 0,
      offsetY: 0,
    };
  


  static function set_cursorMode(value:Null<CursorMode>):Null<CursorMode>
  {
    if (value != null && cursorMode != value)
    {
      cursorMode = value;
      setCursorGraphic(cursorMode);
    }
    return cursorMode;
  }

  /**
   * Synchronous.
   */
  static function setCursorGraphic(?value:CursorMode = null):Void
  {
    if (value == null)
    {
      FlxG.mouse.unload();
      return;
    }

    switch (value)
    {
      case Default:
        if (assetCursorDefault == null)
        {
          var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_DEFAULT_PARAMS.graphic);
          assetCursorDefault = bitmapData;
          applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
        }
        else
        {
          applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
        }

      case Cross:
        if (assetCursorCross == null)
        {
          var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_CROSS_PARAMS.graphic);
          assetCursorCross = bitmapData;
          applyCursorParams(assetCursorCross, CURSOR_CROSS_PARAMS);
        }
        else
        {
          applyCursorParams(assetCursorCross, CURSOR_CROSS_PARAMS);
        }

      case Eraser:
        if (assetCursorEraser == null)
        {
          var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_ERASER_PARAMS.graphic);
          assetCursorEraser = bitmapData;
          applyCursorParams(assetCursorEraser, CURSOR_ERASER_PARAMS);
        }
        else
        {
          applyCursorParams(assetCursorEraser, CURSOR_ERASER_PARAMS);
        }

      case Grabbing:
        if (assetCursorGrabbing == null)
        {
          var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_GRABBING_PARAMS.graphic);
          assetCursorGrabbing = bitmapData;
          applyCursorParams(assetCursorGrabbing, CURSOR_GRABBING_PARAMS);
        }
        else
        {
          applyCursorParams(assetCursorGrabbing, CURSOR_GRABBING_PARAMS);
        }

      case Pointer:
        if (assetCursorPointer == null)
        {
          var bitmapData:BitmapData = Assets.getBitmapData(CURSOR_POINTER_PARAMS.graphic);
          assetCursorPointer = bitmapData;
          applyCursorParams(assetCursorPointer, CURSOR_POINTER_PARAMS);
        }
        else
        {
          applyCursorParams(assetCursorPointer, CURSOR_POINTER_PARAMS);
        }

      default:
        setCursorGraphic(null);
    }
  }

  /**
   * Asynchronous.
   */
  static function loadCursorGraphic(?value:CursorMode = null):Void
  {
    if (value == null)
    {
      FlxG.mouse.unload();
      return;
    }

    switch (value)
    {
      case Default:
        if (assetCursorDefault == null)
        {
          var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_DEFAULT_PARAMS.graphic);
          future.onComplete(function(bitmapData:BitmapData) {
            assetCursorDefault = bitmapData;
            applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
          });
          future.onError(onCursorError.bind(Default));
        }
        else
        {
          applyCursorParams(assetCursorDefault, CURSOR_DEFAULT_PARAMS);
        }

      case Cross:
        if (assetCursorCross == null)
        {
          var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_CROSS_PARAMS.graphic);
          future.onComplete(function(bitmapData:BitmapData) {
            assetCursorCross = bitmapData;
            applyCursorParams(assetCursorCross, CURSOR_CROSS_PARAMS);
          });
          future.onError(onCursorError.bind(Cross));
        }
        else
        {
          applyCursorParams(assetCursorCross, CURSOR_CROSS_PARAMS);
        }

      case Eraser:
        if (assetCursorEraser == null)
        {
          var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_ERASER_PARAMS.graphic);
          future.onComplete(function(bitmapData:BitmapData) {
            assetCursorEraser = bitmapData;
            applyCursorParams(assetCursorEraser, CURSOR_ERASER_PARAMS);
          });
          future.onError(onCursorError.bind(Eraser));
        }
        else
        {
          applyCursorParams(assetCursorEraser, CURSOR_ERASER_PARAMS);
        }

      case Grabbing:
        if (assetCursorGrabbing == null)
        {
          var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_GRABBING_PARAMS.graphic);
          future.onComplete(function(bitmapData:BitmapData) {
            assetCursorGrabbing = bitmapData;
            applyCursorParams(assetCursorGrabbing, CURSOR_GRABBING_PARAMS);
          });
          future.onError(onCursorError.bind(Grabbing));
        }
        else
        {
          applyCursorParams(assetCursorGrabbing, CURSOR_GRABBING_PARAMS);
        }

      case Pointer:
        if (assetCursorPointer == null)
        {
          var future:Future<BitmapData> = Assets.loadBitmapData(CURSOR_POINTER_PARAMS.graphic);
          future.onComplete(function(bitmapData:BitmapData) {
            assetCursorPointer = bitmapData;
            applyCursorParams(assetCursorPointer, CURSOR_POINTER_PARAMS);
          });
          future.onError(onCursorError.bind(Pointer));
        }
        else
        {
          applyCursorParams(assetCursorPointer, CURSOR_POINTER_PARAMS);
        }

      default:
        loadCursorGraphic(null);
    }
  }

  static inline function applyCursorParams(graphic:BitmapData, params:CursorParams):Void
  {
    FlxG.mouse.load(graphic, params.scale, params.offsetX, params.offsetY);
  }

  static function onCursorError(cursorMode:CursorMode, error:String):Void
  {
    trace("Failed to load cursor graphic for cursor mode " + cursorMode + ": " + error);
  }

  public static function registerHaxeUICursors():Void
  {
    CursorHelper.useCustomCursors = true;
    registerHaxeUICursor('default', CURSOR_DEFAULT_PARAMS);
    registerHaxeUICursor('cross', CURSOR_CROSS_PARAMS);
    registerHaxeUICursor('eraser', CURSOR_ERASER_PARAMS);
    registerHaxeUICursor('grabbing', CURSOR_GRABBING_PARAMS);
    registerHaxeUICursor('pointer', CURSOR_POINTER_PARAMS);
  }

  public static function registerHaxeUICursor(id:String, params:CursorParams):Void
  {
    CursorHelper.registerCursor(id, params.graphic, params.scale, params.offsetX, params.offsetY);
  }
}

// https://developer.mozilla.org/en-US/docs/Web/CSS/cursor
enum CursorMode
{
  Default;
  Cross;
  Eraser;
  Grabbing;
  Pointer;
}

/**
 * Static data describing how a cursor should be rendered.
 */
typedef CursorParams =
{
  graphic:String,
  scale:Float,
  offsetX:Int,
  offsetY:Int,
}
