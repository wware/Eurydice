package net.willware.eurydice.core;

/**
 * A unique identifier for an atom or structure. Implementors should
 * implement {@link #toString()} and {@link #equals(Object)}.
 */
public interface UniqueIdSettable extends UniqueId {
    void setNumericValue(int n);
}
