//
// Include file for stable compiler options
//

{$ifdef LIB_DEBUG}
  {$DebugInfo on}
  {$OverflowChecks on}
  {$RangeChecks on}
{$else}
  {$DebugInfo off}
  {$OverflowChecks off}
  {$RangeChecks off}
{$endif}

{$if defined(LIB_DEBUG) or defined(DEBUG)}
  {$StackFrames on}
{$else}
  {$StackFrames off}
{$ifend}

{$ifdef NOASSERT}
  {$Assertions off}
{$else}
  {$Assertions on}
{$endif}

{$Align on}
{$BoolEval off}
{$ExtendedSyntax on}
{$Hints on}
{$IoChecks on}
{$LocalSymbols on}
{$LongStrings on}
{$MinEnumSize 1}
{$OpenStrings on}
{$Optimization on}
{$ReferenceInfo on}
{$SafeDivide off}
{$TypedAddress on}
{$TypeInfo off}
{$VarStringChecks on}
{$Warnings on}
{$WriteableConst off}

{$warn SYMBOL_PLATFORM off}
{$warn UNIT_PLATFORM off}

{$include AdditionalSymbols.inc}

{$ifndef UNICODE} {$message error 'Unicode required'} {$endif}
{$ifndef D2009} {$message error 'D2009 required'} {$endif}

{$Inline on}
{$MethodInfo off}
{$PointerMath on}
{$ScopedEnums off}
{$StringChecks off}

{$ifdef D2011}
  {$StrongLinkTypes off}	// Because this directive defeats the smart linker to a large degree, it can cause inflation of the executable size.
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}	// Extended RTTI => off => smaller EXE
  {$WeakLinkRTTI ON}		// enables more Smart Linking => smaller EXE
{$endif}