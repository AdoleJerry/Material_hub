import {DocumentData, QueryDocumentSnapshot} from "firebase-admin/firestore";

/**
 * Create a Firestore data converter for a specific data type.
 * @return {T}
 */
export function converter<T extends DocumentData>() {
  return {
    /**
       * Converts data of type T to Firestore format.
       * @param {T} data the type
       * @return {DocumentData}
       */
    toFirestore(data: T): DocumentData {
      return data;
    },
    /**
       * Converts Firestore snapshot data to the specified data type T.
       * @param {QueryDocumentSnapshot<DocumentData>} snapshot the type
       * @return {T}
       */
    fromFirestore(
      snapshot: QueryDocumentSnapshot<DocumentData>
    ): T {
      return snapshot.data() as T;
    },
  };
}
