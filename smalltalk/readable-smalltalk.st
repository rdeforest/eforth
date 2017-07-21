currentTheme: aTheme

    CurrentTheme := aTheme new.

    SHTextStylerST80 initialize.

    self runningWorld ifNotNil:
		  [ :w |
				 w backgroundImage ifNil:
            [ w color: CurrentTheme background ]].

    SystemWindow initialize.

    BitBltCanvas releaseClassCachedState.

    self runningWorld ifNotNil:
			[ :w |
        w hideTaskbar.

        CurrentTheme useTaskbar ifTrue: [w showTaskbar].

        CurrentTheme useTaskbar
            ifTrue:  [w showTaskbar]
            ifFalse: [w hideTaskbar].

        w restoreMorphicDisplay 
			].
    
    ^ CurrentTheme
